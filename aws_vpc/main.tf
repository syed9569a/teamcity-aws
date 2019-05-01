#VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "Teamcity VPC"
  }

}

resource "aws_eip" "nat_gw_eip" {
  vpc = true

  tags {
    Name = "TeamCity NAT"
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat_gw_eip.id}"
  subnet_id     = "${aws_subnet.public.id}"

  tags {
    Name = "TeamCity NAT Gateway"
  }
}

resource "aws_subnet" "public" {
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${var.public_cidr_block}"
  vpc_id            = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public TeamCity Subnet"
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "TeamCity Gateway"
  }
}

resource "aws_route_table" "vpc_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc_igw.id}"
  }

  tags {
    Name = "TeamCity Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "vpc_public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.vpc_public.id}"
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