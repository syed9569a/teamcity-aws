variable "ssh_port" {
    description = "This port is to allow SSH Connection"
    default = 22
}

variable "teamcity_port" {
    description = "This port is to allow teamcity to connect"
    default = 8111
}

variable "docker_port" {
    description = "This port is to allow docker connection"
    default = 9000
}

variable "outbound_port" {
    description = "This port is for outbound connection"
    default = 0
}

variable "internal_ip" {
    description = "This cidr block is for connection from NETBuilder Internals"
    type = "map"
    default = {
        "internal_ipv4" = "62.31.26.146/32"
        "outbound_ipv4" = "0.0.0.0/0"
    }
}

variable "vpc_id" {
    type = "string"
    description = "VPC ID in which to deploy RDS"
}