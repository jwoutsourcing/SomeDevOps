resource "aws_instance" "web" { 
  ami = "ami-fbacaaec"
  count = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  availability_zone = "${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}" 
  instance_type = "t2.micro"
  subnet_id = "${element(aws_subnet.pub-net.*.id, count.index)}"
  
  tags = {
    name = "Web Servers"
    buildwith = "Terraform"
  }

}

