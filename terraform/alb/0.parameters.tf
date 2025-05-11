
variable "name" {
  type        = string
  description = "The name of the ALB"
}

variable "is_internal" {
  type        = bool
  description = "Whether the ALB is internal or external"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to deploy the ALB in"
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group"
}

variable "target_groups" {
  type = map(object({
    health_check_path = string
    container_port    = number
    path_pattern      = string
  }))
  description = "The target groups to deploy the ALB in"
}
