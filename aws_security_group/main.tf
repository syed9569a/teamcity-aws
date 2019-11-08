#-----Security Group-------#

resource "aws_security_group" "teamcity_web_sg" {
  name        = "TeamCity_sg"
  description = "Allow TeamCity SSH & HTTP inbound connection"
  vpc_id      = "${var.vpc_id}"

  #SSH

  ingress {
    from_port = "${var.ssh_port}"
    protocol = "tcp"
    to_port = "${var.ssh_port}"
    cidr_blocks = ["62.31.26.146/32"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    protocol = "tcp"
    to_port = "${var.ssh_port}"
    cidr_blocks = ["109.148.96.37/32"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    protocol = "tcp"
    to_port = "${var.ssh_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "${var.teamcity_port}"
    protocol = "tcp"
    to_port = "${var.teamcity_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #DOCKER

//  ingress {
//    from_port = "${var.docker_port}"
//    protocol = "tcp"
//    to_port = "${var.docker_port}"
//    cidr_blocks = ["62.31.26.146/32"]
//  }

  egress {
    from_port = "${var.outbound_port}"
    protocol = "-1"
    to_port = "${var.outbound_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Teamcity Web Security Group"
  }

}

resource "aws_security_group" "rds_sg" {
  name        = "TeamCity_rds_sg"
  description = "TeamCity RDS Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TeamCity RDS Security Group"
  }
}