# the 1 in car-rental-1 can be deleted on 26.05.2025
resource "aws_secretsmanager_secret" "rds" {
  name                    = "car-rental-1/car-rental-service/rds"
  recovery_window_in_days = 0
}

ephemeral "aws_secretsmanager_random_password" "rds" {
  password_length            = 16
  require_each_included_type = true
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string_wo = jsonencode({
    "PASSWORD" = ephemeral.aws_secretsmanager_random_password.rds.random_password
  })
  secret_string_wo_version = 1
}

ephemeral "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  depends_on = [aws_secretsmanager_secret_version.rds]
}

locals {
  db_password = jsondecode(ephemeral.aws_secretsmanager_secret_version.rds.secret_string)["PASSWORD"]
}

