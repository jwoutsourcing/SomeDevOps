

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = "2"
  identifier         = "aurora-cluster-mysql-${count.index}"
  cluster_identifier = "${aws_rds_cluster.default.id}"
  instance_class = "db.t2.small"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "aurora-cluster"
  engine = "mysql"
  availability_zones = ["us-west-2a", "us-west-2b"]
  database_name      = "piesrus"
  master_username    = "pieman"
  master_password    = "M34tp1e5!"
}
