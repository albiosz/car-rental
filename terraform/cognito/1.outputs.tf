output "user_pool_id" {
  value = aws_cognito_user_pool.car-rental.id
}

output "secret_manager_car_rental_service_cognito_client_arn" {
  value = aws_secretsmanager_secret.car_rental_service.arn
}
