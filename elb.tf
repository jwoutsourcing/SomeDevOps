resource "aws_elb" "lb" {
  count              = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  availability_zones = ["${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"]
<<<<<<< HEAD
=======
  subnets            = ["${element(aws_subnet.priv-net.*.id, count.index)}"]
>>>>>>> f3fa6dd128c29b7b6086cd081909f7d4969869b0
  name               = "test-elb"

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
<<<<<<< HEAD
=======
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:acm:us-east-2:953116172017:certificate/7078f7a1-822e-4713-9d43-c61b5df041df"
>>>>>>> f3fa6dd128c29b7b6086cd081909f7d4969869b0
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

<<<<<<< HEAD
  instances                   = ["${element(aws_instance.web.*.id, count.index)}"]
=======
>>>>>>> f3fa6dd128c29b7b6086cd081909f7d4969869b0
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name      = "Test ELB"
    buildwith = "Terraform"
  }
}
