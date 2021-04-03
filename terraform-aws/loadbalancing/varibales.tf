# -- loadbalancing/varibales.tf --

variable "public_sg" {}
variable "public_subnets" {}
variable "tg_port" {}
variable "tg_protocol" {}
variable "vpc_id" {}

variable "lb_healthy_thresold" {}
variable "lb_unhealthy_thresold" {}
variable "lb_timeout" {}
variable "lb_interval" {}

variable "listerner_protocol" {}
variable "listerner_port" {}