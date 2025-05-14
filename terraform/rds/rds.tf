
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Security group for RDS"
  # vpc_id      = var.vpc_id
  vpc_id = "vpc-0243c84397166ebbe"
}


resource "aws_vpc_security_group_ingress_rule" "allow_rds" {
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

resource "aws_db_instance" "default" {
  allocated_storage   = 20
  db_name             = "car_rental"
  engine              = "postgres"
  engine_version      = "17.2"
  instance_class      = "db.t4g.micro"
  username            = "albert"
  password            = "mazur123"
  publicly_accessible = true
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  # set vpc
}
