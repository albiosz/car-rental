resource "aws_db_instance" "car_rental" {
  identifier     = "car-rental"
  instance_class = "db.t4g.micro"

  allocated_storage = var.do_restore_from_snapshot ? null : 20
  engine            = var.do_restore_from_snapshot ? null : "postgres"
  engine_version    = var.do_restore_from_snapshot ? null : "17.2"

  db_name             = var.do_restore_from_snapshot ? null : "car_rental"
  username            = var.do_restore_from_snapshot ? null : "postgres"
  password_wo         = local.db_password
  password_wo_version = aws_secretsmanager_secret_version.rds.secret_string_wo_version

  snapshot_identifier = var.do_restore_from_snapshot ? var.rds_snapshot_identifier : null

  port                = 5432
  publicly_accessible = false

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}
