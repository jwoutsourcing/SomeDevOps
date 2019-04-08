provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/app/.aws/credentials"
}

resource "aws_vpc" "test-net" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags {
    name = "Test Network"
    buildwith = "Terraform"
  }
}

resource "aws_subnet" "pub-net" {
  vpc_id = "${aws_vpc.test-net.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags {
    name = "Public-net"
    buildwith = "Terraform"
  }
}

resource "aws_subnet" "priv-net" {
   vpc_id = "${aws_vpc.test-net.id}"
   cidr_block = "10.0.2.0/24"
   availability_zone = "us-east-1a"
  
   tags {
     name = "Private-sub-net"
     buildwith = "Terraform"
   }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.test-net.id}"
 
  tags {
    name = "Internet Gateway"
    buildwith = "Terraform"
  }
}

resource "aws_route" "r" {
  route_table_id = "${aws_vpc.test-net.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  

}

resource "aws_eip" "elastic_ip" {
  vpc = "true"
  depends_on = [ "aws_internet_gateway.internet-gateway" ]
}

resource "aws_route_table" "pri-route-table" {
  vpc_id = "${aws_vpc.test-net.id}"
 
  tags  {
    name = "private route table"
    buildwith = "Terraform"
  }
}


resource "aws_nat_gateway" "test-gw" {
   allocation_id = "${aws_eip.elastic_ip.id}"
   subnet_id = "${aws_subnet.pub-net.id}"
   depends_on = [ "aws_internet_gateway.internet-gateway" ]

  tags {
    name = "Nat GW"
    buildwith = "Terraform"
  }
}

resource "aws_route" "pri-route" {
   route_table_id = "${aws_route_table.pri-route-table.id}"
   destination_cidr_block = "0.0.0.0/0"
   nat_gateway_id = "${aws_nat_gateway.test-gw.id}"
}


resource "aws_route_table_association" "pub-sub-ass" {
    subnet_id = "${aws_subnet.pub-net.id}"
    route_table_id = "${aws_vpc.test-net.main_route_table_id}"
}

resource "aws_route_table_association" "priv-sub-ass" {
     subnet_id = "${aws_subnet.priv-net.id}"
     route_table_id = "${aws_route_table.pri-route-table.id}"
}



