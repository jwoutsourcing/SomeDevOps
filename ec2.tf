provider "aws" {
  access_key = "AKIAJGN5WKB5355XOIPQ"
  secret_key = "l+8kLSbtv9HBynGomcB0dgVdX7PAl2B3HfBaNzTf"
  region     = "us-west-2"
}

resource "aws_instance" "example" {
	ami = "ami-7dc6601d"
  instance_type = "t2.micro"
}
