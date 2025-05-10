resource "aws_vpc" "car_rental" {
  cidr_block = var.cidr
  tags = {
    Name = "car-rental-vpc"
  }
}
