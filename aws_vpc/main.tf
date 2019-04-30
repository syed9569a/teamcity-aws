#VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "Teamcity VPC"
  }

}
#NAT_GW_EIP
resource "aws_eip" "nat_gw_eip" {

  vpc = true

  tags {

    Name = "Teamcity NAT"

  }

}
#NAT_GW
resource "aws_nat_gateway" "gw" {

  allocation_id = "${aws_eip.nat_gw_eip.id}"
  subnet_id = "${aws_subnet.private.id}"

  tags {

    Name = "Teamcity NAT Gateway"

  }

}
#VPC_IGW
resource "aws_internet_gateway" "vpc_igw" {

  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Teamcity Gateway"
  }

}

#VPC_Subnet_Public
resource "aws_subnet" "public" {
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${var.public_cidr_block}"
  vpc_id            = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public TeamCity Subnet"
  }
}

resource "aws_subnet" "private" {
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${element(var.private_cidr_block, count.index)}"
  count             = "${length(var.private_cidr_block)}"
  vpc_id            = "${aws_vpc.vpc.id}"

  tags {
    Name = "${format("TeamCity Private Subnet %d", count.index + 1)}"
  }
}

resource "aws_db_subnet_group" "rds" {
  name        = "teamcity-subnet-group"
  description = "TeamCity RDS Subnet Group"
  subnet_ids  = ["${aws_subnet.private.*.id}"]

  tags {
    Name = "TeamCity RDS Subnet Group"
  }
}

#Route_Table
resource "aws_route_table" "vpc_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "TeamCity Private Subnet's Route Table"
  }
}

resource "aws_route_table_association" "vpc_private" {
  count          = "${var.length}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.vpc_private.id}"
}