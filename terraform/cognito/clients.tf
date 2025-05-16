# Client for the car-rental-service
resource "aws_cognito_user_pool_client" "car-rental-service" {
  name            = "car-rental-service"
  user_pool_id    = aws_cognito_user_pool.car-rental.id
  generate_secret = true

  allowed_oauth_flows = [
    "client_credentials"
  ]
  allowed_oauth_scopes = [
    "${aws_cognito_resource_server.currency-converter.identifier}/read"
  ]
  allowed_oauth_flows_user_pool_client = true

  prevent_user_existence_errors = "ENABLED"

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    # "ALLOW_USER_PASSWORD_AUTH",
    # "ALLOW_ADMIN_USER_PASSWORD_AUTH"
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
  name         = "frontend"
  user_pool_id = aws_cognito_user_pool.car-rental.id

  generate_secret        = false
  id_token_validity      = 24
  refresh_token_validity = 90
  token_validity_units {
    id_token      = "hours"
    refresh_token = "days"
  }

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [
    "implicit", # this setting allow user to get access and id token just by logging in, change to token in the UI URL to get the tokens
    "code"
  ]
  allowed_oauth_scopes = [
    "openid"
  ]
  callback_urls = [
    "http://localhost:8000"
  ]

  # this settings allows to use data about user from cognito
  supported_identity_providers = ["COGNITO"]

  prevent_user_existence_errors = "ENABLED"
  # these flows specify, how users can get authenticated using the user pool API or SDK (not the UI or domain of my user pool)
  # they are different from allowed_oauth_flows, which define what a user will receive (code, tokens, etc.), if they are successfully authenticated
  # the flows *do not define*, how user can get authenticated using the UI
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH", # allows to refresh the access token, refresh token usually has a longer validity (like 90 days)
    "ALLOW_USER_PASSWORD_AUTH", # allows to log in by using user name and password
  ]
}
