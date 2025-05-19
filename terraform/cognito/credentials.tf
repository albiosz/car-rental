# the 1 in car-rental-1 can be deleted on 26.05.2025
resource "aws_secretsmanager_secret" "car_rental_service" {
  name                    = "car-rental-1/car-rental-service/cognito-client"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "car_rental_service" {
  secret_id = aws_secretsmanager_secret.car_rental_service.id
  secret_string = jsonencode({
    "ID"     = aws_cognito_user_pool_client.car-rental-service.id
    "SECRET" = aws_cognito_user_pool_client.car-rental-service.client_secret
  })
}
