variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-2"
}

resource "aws_instance" "example" {
	ami = "ami-7dc6601d"
  instance_type = "t2.micro"

 provisioner "local-exec" {
    command = "yum install -y puppet mariadb-server"

  }
}

