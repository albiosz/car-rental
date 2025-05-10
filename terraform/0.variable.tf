
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


variable "aws_access_key" {
  description = "The IAM public access key"
}

variable "aws_secret_key" {
  description = "IAM secret access key"
}

variable "aws_region" {
  description = "The AWS region things are created in"
}

variable "ec2_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role name"
  default     = "myEcsAutoScaleRole"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "bradfordhamilton/crystal_blockchain:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8000

}

variable "health_check_path" {
  default = "/health"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "availability_zones" {
  description = "AZs to deploy"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "public_alb_port" {
  description = "The port the ALB listens on"
  type        = number
  default     = 8000
}

variable "internal_alb_from_port" {
  description = "The minimum port the ALB listens on"
  type        = number
  default     = 8000
}

variable "internal_alb_to_port" {
  description = "The maximum port the ALB listens on"
  type        = number
  default     = 8080
}

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
