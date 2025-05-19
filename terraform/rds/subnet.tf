resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "car-rental-rds"
  subnet_ids = var.subnet_ids
}
