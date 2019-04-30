provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

data "aws_availability_zones" "zones" {}

module "aws_vpc" {
    source = "aws_vpc"
    availability_zones = ["${data.aws_availability_zones.zones.names}"]
}

module "aws_security_group" {
    source = "./aws_security_group"
    vpc_id = "${module.aws_vpc.vpc_id}"
}

module "aws_rds" {
    source = "./aws_rds"
    db_name                = "${var.db_name}"
    db_password            = "${var.db_password}"
    db_username            = "${var.db_username}"
    db_subnet_group_name   = "${module.aws_vpc.db_subnet_group_name}"
    dns_name               = "pg"
    instance_identifier    = "${var.db_name}"
    vpc_id                 = "${module.aws_vpc.vpc_id}"
    private_subnet_id      = ["${module.aws_vpc.private_subnet}"]
    service_name           = "TeamCity"
    vpc_security_group_ids = "${module.aws_security_group.rds_security_groups_id}"
}

#S3 bucket name has to be unique
module "backup_bucket" {
    source      = "./aws_s3"
    name        = "${var.unique_s3_name}"
    description = "TeamCity Backups"
}

module "ec2" {
    source                 = "./ec2_instance"
    ami                    = "${var.debian_ami}"
    db_username            = "${var.db_username}"
    db_password            = "${var.db_password}"
    db_name                = "${var.db_name}"
    db_port                = "${module.aws_rds.db_port}"
    db_url                 = "${module.aws_rds.database_address}"
    key_name               = "${var.key_name}"
    public_subnet_id       = "${module.aws_vpc.public_subnet}"
    ssh_path               = "${var.ssh_path}"
    vpc_security_group_ids = "${module.aws_security_group.web_security_groups_id}"
}
