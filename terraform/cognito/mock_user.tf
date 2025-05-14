
# Mock user for testing
resource "aws_cognito_user" "testuser" {
  user_pool_id   = aws_cognito_user_pool.car-rental.id
  username       = "testuser@example.com"
  password       = "P@ssw0rd123"
  enabled        = true
  message_action = "SUPPRESS"


  attributes = {
    email          = "testuser@example.com"
    email_verified = true
    name           = "Test User"
    family_name    = "User"
    phone_number   = "+1234567890"
  }

  depends_on = [aws_cognito_user_pool.car-rental]
}
