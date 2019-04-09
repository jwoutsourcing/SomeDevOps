resource "aws_security_group" "sec-group" {
  name        = "3-tier Security Group"
  description = "3-tier Security Group"

  # allowing SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.priv-net.*.cidr_block}"]
  }

  # allowing web connections since it runs a web server
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.priv-net.*.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${ aws_vpc.test-net.id }"
}
