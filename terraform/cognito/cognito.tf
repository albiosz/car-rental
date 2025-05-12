
resource "aws_cognito_user_pool" "car-rental" {
  name = "car-rental-users"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  # skipped schema for now
}

resource "aws_cognito_resource_server" "currency-converter" {
  identifier   = "currency-converter"
  name         = "currency-converter"
  user_pool_id = aws_cognito_user_pool.car-rental.id

  scope {
    scope_name        = "read"
    scope_description = "Read access"
  }
}

resource "aws_cognito_user_pool_domain" "car-rental" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.car-rental.id
}

# Client for the car-rental-service
resource "aws_cognito_user_pool_client" "car-rental-service" {
  name            = "car-rental-service"
  user_pool_id    = aws_cognito_user_pool.car-rental.id
  generate_secret = true

  allowed_oauth_flows = ["client_credentials"]
  allowed_oauth_scopes = [
    "${aws_cognito_resource_server.currency-converter.identifier}/read"
  ]
  allowed_oauth_flows_user_pool_client = true

  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]


  access_token_validity  = 24
  refresh_token_validity = 90
  token_validity_units {
    access_token  = "hours"
    refresh_token = "days"
  }
}


# Frontend client
resource "aws_cognito_user_pool_client" "frontend" {
  name = "frontend"

  user_pool_id                  = aws_cognito_user_pool.car-rental.id
  generate_secret               = false
  refresh_token_validity        = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}
