
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_5432" {
  security_group_id = aws_security_group.rds_security_group.id
  # TODO: change to private and public subnet cidr
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_1" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "car-rental-rds"
  subnet_ids = var.subnet_ids
}


resource "aws_db_instance" "car_rental" {
  identifier     = "car-rental"
  instance_class = "db.t4g.micro"

  allocated_storage = var.do_restore_from_snapshot ? null : 20
  engine            = var.do_restore_from_snapshot ? null : "postgres"
  engine_version    = var.do_restore_from_snapshot ? null : "17.2"

  db_name  = var.do_restore_from_snapshot ? null : "car_rental"
  username = var.do_restore_from_snapshot ? null : "postgres"
  password = var.do_restore_from_snapshot ? null : "mazur123"

  snapshot_identifier = var.do_restore_from_snapshot ? var.rds_snapshot_identifier : null

  port                = 5432
  publicly_accessible = false

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}
