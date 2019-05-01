variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}

variable "region" {
  default = "eu-west-1"
}

variable "db_name" {
  default = "teamcity"
}

variable "db_password" {
  type = "string"
}

variable "db_username" {
  default = "teamcityuser"
}

variable "unique_s3_name" {
  default = "polymerisation-teamcity-unique"
}

variable "key_name" {
  default = "aws_priv"
}

variable "debian_ami" {
  default = "ami-0764a46039d5d5fa5"
}

variable "ssh_path" {
  default = "~/.ssh"
}