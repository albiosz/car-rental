# ALB security Group
resource "aws_security_group" "lb" {
  name   = "car-rental-service-load-balancer"
  vpc_id = var.vpc_id

  tags = {
    Name = "car-rental-service-load-balancer"
  }
}

# Load Balancer is available under port 80
resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.alb_port
  ip_protocol       = "tcp"
  to_port           = var.alb_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_1" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}
