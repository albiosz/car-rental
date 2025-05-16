variable "vpc_id" {
  description = "ID of the VPC where the bastion host will be launched"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the bastion host will be launched"
  type        = string
}
