resource "aws_elb" "lb" {
  count              = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  availability_zones = ["${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"]
  subnets            = ["${element(aws_subnet.priv-net.*.id, count.index)}"]
  name               = "test-elb"

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
  }

  access_logs {
    bucket   = "steve-wood-dev"
    interval = 60
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name      = "Test ELB"
    buildwith = "Terraform"
  }
}
