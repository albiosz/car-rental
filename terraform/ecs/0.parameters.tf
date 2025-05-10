variable "cluster_id" {
  type        = string
  description = "The ID of the ECS cluster"
}

variable "template_link" {
  type        = string
  description = "The link to the template file"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "The ARN of the ECS task execution role"
}

variable "fargate_cpu" {
  type        = number
  description = "The CPU of the Fargate task"
}

variable "fargate_memory" {
  type        = number
  description = "The memory of the Fargate task"
}

variable "app_image" {
  type        = string
  description = "The image of the application"
}

variable "container_port" {
  type        = number
  description = "The port of the application"
}

variable "aws_region" {
  type        = string
  description = "The region of the application"
}

variable "alb_target_group_arn" {
  type        = string
  description = "The ARN of the ALB target group"
}

variable "security_group_id" {
  type        = string
  description = "The security group with which the container will run"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnets of the VPC"
}
