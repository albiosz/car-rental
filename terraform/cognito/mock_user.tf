
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

resource "aws_cognito_user" "admin" {
  user_pool_id   = aws_cognito_user_pool.car-rental.id
  username       = "admin@example.com"
  password       = "P@ssw0rd123"
  enabled        = true
  message_action = "SUPPRESS"

  attributes = {
    email          = "admin@example.com"
    email_verified = true
    name           = "Admin User"
    family_name    = "User"
    phone_number   = "+1234567890"
  }

  depends_on = [aws_cognito_user_pool.car-rental]
}

resource "aws_cognito_user_in_group" "admin_group" {
  user_pool_id = aws_cognito_user_pool.car-rental.id
  group_name   = aws_cognito_user_group.admin.name
  username     = aws_cognito_user.admin.username

  depends_on = [aws_cognito_user_group.admin, aws_cognito_user.admin]
}

