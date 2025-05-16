output "alb_hostname" {
  value = module.public_alb.alb_dns_name
}

output "bastion_host_public_ip" {
  value = module.bastion_host.bastion_host_public_ip
}

output "rds_endpoint" {
  value = module.rds.host
}

