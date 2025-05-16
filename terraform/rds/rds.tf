
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_5432" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
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
  identifier = "car-rental"

  allocated_storage = 20
  instance_class    = "db.t4g.micro"
  engine            = "postgres"
  engine_version    = "17.2"

  db_name             = "car_rental"
  username            = "postgres"
  password            = "mazur123"
  port                = 5432
  publicly_accessible = true

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  # set vpc
}
