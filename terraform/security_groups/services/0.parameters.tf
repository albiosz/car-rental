
variable "name" {
  type        = string
  description = "The name of the security group"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "service_port" {
  type        = number
  description = "The port the service listens on"
}

variable "alb_security_group_id" {
  type        = string
  description = "The ID of the ALB security group"
}
