resource "aws_instance" "teamcity" {
  ami                         = "${var.ami}"
  instance_type               = "t2.medium"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${var.public_subnet_id}"
  user_data                   = "${data.template_file.teamcity_userdata.rendered}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  associate_public_ip_address = true

  tags = {
    Name = "TeamCity"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "teamcity_userdata" {
  template = "${file("${path.module}/scripts/setup.sh")}"

  vars {
    db_url      = "${var.db_url}"
    db_port     = "${var.db_port}"
    db_name     = "${var.db_name}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
  }
}
