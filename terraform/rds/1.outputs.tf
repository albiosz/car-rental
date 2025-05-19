output "host" {
  value = aws_db_instance.car_rental.address
}

output "port" {
  value = aws_db_instance.car_rental.port
}

output "db_name" {
  value = aws_db_instance.car_rental.db_name
}

output "username" {
  value = aws_db_instance.car_rental.username
}

output "secret_manger_arn" {
  value = aws_secretsmanager_secret.rds.arn
}
