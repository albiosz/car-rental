# ALB security Group
resource "aws_security_group" "lb" {
  name   = "car-rental-service-load-balancer"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "car-rental-service-load-balancer"
  }
}

# Load Balancer is available under port 80
resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
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


# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name   = "car-rental-service-ecs-tasks"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id            = aws_security_group.ecs_tasks.id
  referenced_security_group_id = aws_security_group.lb.id
  from_port                    = var.app_port
  ip_protocol                  = "tcp"
  to_port                      = var.app_port
}

# resource "aws_vpc_security_group_ingress_rule" "ecs_allow_8000" {
#   security_group_id = aws_security_group.ecs_tasks.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = var.app_port
#   ip_protocol       = "tcp"
#   to_port           = var.app_port
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_2" {
  security_group_id = aws_security_group.ecs_tasks.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_2" {
  security_group_id = aws_security_group.ecs_tasks.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}
