output "user-pool-id" {
  value = aws_cognito_user_pool.car-rental.id
}

output "car-rental-service-client-id" {
  value = aws_cognito_user_pool_client.car-rental-service.id
}

output "car-rental-service-client-secret" {
  value = aws_cognito_user_pool_client.car-rental-service.client_secret
}
