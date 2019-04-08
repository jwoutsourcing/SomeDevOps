

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = "2"
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
