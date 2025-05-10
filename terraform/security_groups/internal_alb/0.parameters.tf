
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "alb_from_port" {
  type        = number
  description = "The minimum port the ALB listens on"
  default     = 8000
}

variable "alb_to_port" {
  type        = number
  description = "The maximum port the ALB listens on"
  default     = 8080
}
