output "car-rental-service-client-id" {
  value = aws_cognito_user_pool_client.car-rental-service.id
}

output "user-pool-id" {
  value = aws_cognito_user_pool.car-rental.id
}
