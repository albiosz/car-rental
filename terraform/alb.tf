resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "cb-load-balancer"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.lb.id]
  internal           = false
}

resource "aws_lb_target_group" "app" {
  name        = "cb-target-group"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app.arn
    type             = "forward"
  }
}
