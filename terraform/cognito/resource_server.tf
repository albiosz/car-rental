resource "aws_cognito_resource_server" "currency-converter" {
  identifier   = "currency-converter"
  name         = "currency-converter"
  user_pool_id = aws_cognito_user_pool.car-rental.id

  scope {
    scope_name        = "read"
    scope_description = "Read access"
  }
}
