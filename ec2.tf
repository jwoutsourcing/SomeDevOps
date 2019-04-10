<<<<<<< HEAD
resource "aws_instance" "web" {
  ami               = "ami-fbacaaec"
  count             = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  availability_zone = "${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"
  instance_type     = "t2.micro"
  subnet_id         = "${element(aws_subnet.pub-net.*.id, count.index)}"

  tags = {
    name      = "Web Servers"
    buildwith = "Terraform"
  }
}
=======
data "aws_ami" "amazon-linux" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["amzn*86_64-gp2"]
  }

  owners = ["137112412989"]
}

resource "aws_placement_group" "web" {
  name     = "web"
  strategy = "cluster"
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "asg_launch"
  image_id      = "${data.aws_ami.amazon-linux.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  count                     = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  availability_zones        = ["${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"]
  name                      = "this-asg"
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  max_size                  = "5"
  min_size                  = "3"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  placement_group           = "${aws_placement_group.web.id}"
  vpc_zone_identifier       = ["${element(aws_subnet.pub-net.*.id, count.index)}"]
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = "${aws_autoscaling_group.this.*.id}"
  elb                    = "${aws_elb.lb.*.id}"
}
>>>>>>> f3fa6dd128c29b7b6086cd081909f7d4969869b0
