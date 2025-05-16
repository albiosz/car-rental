resource "aws_vpc" "car_rental" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "car-rental-vpc"
  }
}
