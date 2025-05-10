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
  alb_port = var.public_alb_port
}

module "internal_alb_security_group" {
  source        = "./security_groups/internal_alb"
  vpc_id        = module.vpc.vpc_id
  alb_from_port = var.internal_alb_from_port
  alb_to_port   = var.internal_alb_to_port
}

module "security_groups_services" {
  for_each              = var.services
  source                = "./security_groups/services"
  vpc_id                = module.vpc.vpc_id
  service_port          = each.value.container_port
  alb_security_group_id = each.value.is_public ? module.public_alb_security_group.security_group_id : module.internal_alb_security_group.security_group_id
}
