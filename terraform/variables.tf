variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
  default = "10.0.10.0/24"
}
variable "avail_zone" {
  default = "eu-west-3b"
}
variable "env_prefix" {
  default = "dev"
}
variable "my_ip" {
  default = "87.241.157.146/32"
}
variable "jenkins_ip" {
  default = "81.16.12.44/32"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "region" {
  default = "eu-west-3"
}
