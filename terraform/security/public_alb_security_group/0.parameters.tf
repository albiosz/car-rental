
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "alb_port" {
  type        = number
  description = "The port the ALB listens on"
  default     = 80
}
