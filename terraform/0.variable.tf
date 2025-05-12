# AWS credentials
variable "aws_access_key" {
  description = "The IAM public access key"
}

variable "aws_secret_key" {
  description = "IAM secret access key"
}

variable "aws_region" {
  description = "The AWS region things are created in"
}

# VPC
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.17.0.0/16"
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  type        = list(string)
  default     = ["172.17.1.0/24", "172.17.2.0/24"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  type        = list(string)
  default     = ["172.17.101.0/24", "172.17.102.0/24"]
}

variable "availability_zones" {
  description = "AZs to deploy"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

# Internal ALB security group ports
variable "internal_alb_from_port" {
  description = "The minimum port the ALB listens on"
  type        = number
  default     = 8080
}

variable "internal_alb_to_port" {
  description = "The maximum port the ALB listens on"
  type        = number
  default     = 8080
}

# Cognito
variable "cognito_domain_prefix" {
  type        = string
  description = "The prefix in the domain for token endpoints e.g. https://{prefix}.auth.eu-central.amazoncognito.com/oauth2/token"
  default     = "car-rental"
}

# Services available in the cluster
variable "services" {
  type = map(object({
    name           = string
    is_public      = bool
    container_port = number
    template_link  = string
    fargate_cpu    = number
    fargate_memory = number
    app_image      = string

    alb_target_group = object({
      health_check_path = string
      container_port    = number
      path_pattern      = string
    })
  }))
}
