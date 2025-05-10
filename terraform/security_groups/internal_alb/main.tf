
resource "aws_security_group" "internal_alb" {
  name   = "car-rental-service-internal-alb"
  vpc_id = var.vpc_id

  tags = {
    Name = "car-rental-service-internal-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id = aws_security_group.internal_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.alb_from_port
  ip_protocol       = "tcp"
  to_port           = var.alb_to_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id = aws_security_group.internal_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_1" {
  security_group_id = aws_security_group.internal_alb.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}
