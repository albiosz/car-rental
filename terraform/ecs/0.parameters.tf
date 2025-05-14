variable "name" {
  type        = string
  description = "The name of the service"
}

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

# car rental only service parameters
variable "internal_alb_dns_name" {
  type        = string
  description = "The DNS name of the internal ALB"
}

variable "cognito_user_pool_id" {
  type = string
}

variable "cognito_client_id" {
  type = string
}

variable "cognito_client_secret" {
  type = string
}

variable "cognito_domain_prefix" {
  type        = string
  description = "The prefix in the domain for token endpoints e.g. https://{prefix}.auth.eu-central.amazoncognito.com/oauth2/token"
  default     = "car-rental"
}

# car rental service database parameters
variable "db_host" {
  type        = string
  description = "The host of the database"
}

variable "db_port" {
  type        = number
  description = "The port of the database"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
}

variable "db_username" {
  type        = string
  description = "The username of the database"
}
