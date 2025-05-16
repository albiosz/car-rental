terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "iam" {
  source = "./iam"
}

module "vpc" {
  source             = "./vpc"
  cidr               = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

module "public_alb_security_group" {
  source   = "./security_groups/public_alb"
  vpc_id   = module.vpc.vpc_id
  alb_port = var.services["car-rental-service"].container_port
}

module "internal_alb_security_group" {
  source        = "./security_groups/internal_alb"
  vpc_id        = module.vpc.vpc_id
  alb_from_port = var.internal_alb_from_port
  alb_to_port   = var.internal_alb_to_port
}

module "security_groups_services" {
  for_each              = var.services
  name                  = each.key
  source                = "./security_groups/services"
  vpc_id                = module.vpc.vpc_id
  service_port          = each.value.container_port
  alb_security_group_id = each.value.is_public ? module.public_alb_security_group.security_group_id : module.internal_alb_security_group.security_group_id
}

locals {
  internal_alb_target_groups = {
    for service, config in var.services : service => config.alb_target_group if !config.is_public
  }

  public_alb_target_groups = {
    for service, config in var.services : service => config.alb_target_group if config.is_public
  }
}

module "internal_alb" {
  source            = "./alb"
  name              = "car-rental-internal-alb"
  is_internal       = true
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.private_subnets
  security_group_id = module.internal_alb_security_group.security_group_id
  target_groups     = local.internal_alb_target_groups
}

module "public_alb" {
  source            = "./alb"
  name              = "car-rental-public-alb"
  is_internal       = false
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.public_subnets
  security_group_id = module.public_alb_security_group.security_group_id
  target_groups     = local.public_alb_target_groups
}

resource "aws_ecs_cluster" "car_rental" {
  name = "car-rental"
}

module "cognito" {
  source        = "./cognito"
  domain_prefix = var.cognito_domain_prefix
}

module "rds" {
  source                   = "./rds"
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  do_restore_from_snapshot = var.do_restore_rds_from_snapshot
  rds_snapshot_identifier  = var.rds_snapshot_identifier
}

module "bastion_host" {
  source           = "./bastion_host"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]
}

module "services" {
  for_each                    = var.services
  source                      = "./ecs"
  name                        = each.key
  cluster_id                  = aws_ecs_cluster.car_rental.id
  template_link               = each.value.template_link
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  fargate_cpu                 = each.value.fargate_cpu
  fargate_memory              = each.value.fargate_memory
  app_image                   = each.value.app_image
  container_port              = each.value.container_port
  aws_region                  = var.aws_region
  alb_target_group_arn        = each.value.is_public ? module.public_alb.target_group_arns[each.key] : module.internal_alb.target_group_arns[each.key]
  security_group_id           = module.security_groups_services[each.key].security_group_id
  private_subnets             = module.vpc.private_subnets
  internal_alb_dns_name       = module.internal_alb.alb_dns_name
  # only car rental service attributes
  cognito_user_pool_id  = module.cognito.user-pool-id
  cognito_client_id     = module.cognito.car-rental-service-client-id
  cognito_client_secret = module.cognito.car-rental-service-client-secret
  db_host               = module.rds.host
  db_port               = module.rds.port
  db_name               = module.rds.db_name
  db_username           = module.rds.username
}


