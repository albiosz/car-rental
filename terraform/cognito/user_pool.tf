
resource "aws_cognito_user_pool" "car-rental" {
  name = "car-rental-users"

  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

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

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = false
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    required            = false
  }

  schema {
    name                = "phone_number"
    attribute_data_type = "String"
    required            = false
  }
}

resource "aws_cognito_user_pool_domain" "car-rental" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.car-rental.id
}
