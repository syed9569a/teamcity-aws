output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_subnet" {
  value = ["${aws_subnet.private.*.id}"]
}

output "db_subnet_group_name" {
  value = "${aws_db_subnet_group.rds.name}"
}

output "public_subnet" {
  value = "${aws_subnet.public.id}"
}