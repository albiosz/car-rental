# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name   = "car-rental-service-ecs-tasks"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id            = aws_security_group.ecs_tasks.id
  referenced_security_group_id = var.alb_security_group_id
  from_port                    = var.service_port
  ip_protocol                  = "tcp"
  to_port                      = var.service_port
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
