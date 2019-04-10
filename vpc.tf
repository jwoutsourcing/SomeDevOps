resource "aws_vpc" "test-net" {
  cidr_block           = "${var.vpc["cidr_block"]}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    name      = "Test Network"
    buildwith = "Terraform"
  }
}

resource "aws_subnet" "pub-net" {
  vpc_id                  = "${aws_vpc.test-net.id}"
  count                   = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  cidr_block              = "${cidrsubnet(var.vpc["cidr_block"], var.vpc["subnet_bits"], count.index)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"

  tags {
    name      = "Public-net"
    buildwith = "Terraform"
  }
}

resource "aws_subnet" "priv-net" {
  vpc_id            = "${aws_vpc.test-net.id}"
  count             = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
  cidr_block        = "${cidrsubnet(var.vpc["cidr_block"], var.vpc["subnet_bits"], count.index)}"
  availability_zone = "${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"

  tags {
    name      = "Private-sub-net"
    buildwith = "Terraform"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.test-net.id}"

  tags {
    name      = "Internet Gateway"
    buildwith = "Terraform"
  }
}

resource "aws_route" "r" {
  route_table_id         = "${aws_vpc.test-net.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

resource "aws_eip" "elastic_ip" {
  vpc        = "true"
  depends_on = ["aws_internet_gateway.internet-gateway"]
}

resource "aws_route_table" "pri-route-table" {
  vpc_id = "${aws_vpc.test-net.id}"

  tags {
    name      = "private route table"
    buildwith = "Terraform"
  }
}

resource "aws_nat_gateway" "test-gw" {
  allocation_id = "${aws_eip.elastic_ip.id}"
  subnet_id     = "${element(aws_subnet.pub-net.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.internet-gateway"]

  tags {
    name      = "Nat GW"
    buildwith = "Terraform"
  }
}

resource "aws_route" "pri-route" {
  route_table_id         = "${aws_route_table.pri-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.test-gw.id}"
}

resource "aws_route_table_association" "pub-sub-ass" {
  subnet_id      = "${element(aws_subnet.pub-net.*.id, count.index)}"
  route_table_id = "${aws_vpc.test-net.main_route_table_id}"
}

resource "aws_route_table_association" "priv-sub-ass" {
  subnet_id      = "${element(aws_subnet.priv-net.*.id, count.index)}"
  route_table_id = "${aws_route_table.pri-route-table.id}"
}
