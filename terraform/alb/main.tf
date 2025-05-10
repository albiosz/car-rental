resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name               = var.name
  subnets            = var.subnets
  security_groups    = [var.security_group_id]
  internal           = var.is_internal
}

resource "aws_lb_target_group" "service" {
  for_each    = var.target_groups
  name        = each.key
  port        = each.value.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200,404"
    timeout             = "3"
    path                = each.value.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "alb" {
  for_each          = var.target_groups
  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[each.key].arn
  }
}

