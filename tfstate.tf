terraform {
  backend "s3" {
    shared_credentials_file = "/app/.aws/credentials"
    bucket                  = "steve-wood-dev"
    key                     = "terraform/tfstate"
    region                  = "us-east-1"
  }
}

resource "aws_s3_bucket" "tfstatebucket" {
  bucket = "rl.tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name = "Terraform state bucket"
  }
}

resource "aws_dynamodb_table" "tfstatedynamotable" {
  name           = "rl.tfstate"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "Terraform state consistency"
  }
}
