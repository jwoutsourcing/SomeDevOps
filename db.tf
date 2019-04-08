resource "aws_rds_cluster_instance" "cluster_instances" {
  count = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  identifier         = "aurora-cluster-mysql-${count.index}"
  cluster_identifier = "${aws_rds_cluster.default.id}"
  instance_class = "db.t2.small"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "aurora-cluster"
  engine = "mysql"
  count = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  availability_zone = "${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}" 
  database_name      = "piesrus"
  master_username    = "pieman"
  master_password    = "M34tp1e5!"
}

resource "aws_security_group" "rds" {
  name        = "terraform_rds_security_group"
  vpc_id      = "${aws_vpc.test-net.id}"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.rds.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "rds-security-group"
    buildwith = "Terraform"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name = "rds-subnet"
  subnet_id = "${element(aws_subnet.priv-net.*.id, count.index)}"
}
