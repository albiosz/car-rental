
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

resource "aws_cognito_user_pool_client" "car-rental-service" {
  name = "car-rental-service"

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

resource "null_resource" "create_initial_user" {
  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp admin-create-user \
        --user-pool-id ${aws_cognito_user_pool.car-rental.id} \
        --username testuser@example.com \
        --user-attributes Name=email,Value=testuser@example.com Name=email_verified,Value=true \
        --message-action SUPPRESS

      aws cognito-idp admin-set-user-password \
        --user-pool-id ${aws_cognito_user_pool.car-rental.id} \
        --username testuser@example.com \
        --password "P@ssw0rd123" \
        --permanent
    EOT
  }

  depends_on = [aws_cognito_user_pool.car-rental]
}
