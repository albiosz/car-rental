output "host" {
  value = aws_db_instance.default.address
}

output "port" {
  value = aws_db_instance.default.port
}

output "db_name" {
  value = aws_db_instance.default.db_name
}

output "username" {
  value = aws_db_instance.default.username
}

