variable "availability_zone" {
    default = "eu-west-1b"
}

variable "volume_size" {
    default = "8"
}

variable "type" {
    default = "gp2"
}

variable "device_name" {
    default = "/dev/sdh"
}

variable "instance_id" {
  type  = "string"
}