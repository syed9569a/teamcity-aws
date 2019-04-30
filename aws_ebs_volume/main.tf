resource "aws_ebs_volume" "ebs_1"{
  availability_zone = "${var.availability_zone}"
  size = "${var.volume_size}"
  encrypted = true
  type = "${var.type}"
  tags {
    Name = "Custom_EBS_Volume"
  }
}

resource "aws_volume_attachment" "ebs_att"{
  device_name = "${var.device_name}"
  volume_id = "${aws_ebs_volume.ebs_1.id}"
  instance_id = "${var.instance_id}"
}