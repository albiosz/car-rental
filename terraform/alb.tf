resource "aws_lb" "internet_facing" {
  load_balancer_type = "application"
  name               = "car-rental-service"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb.id]
  internal           = false
}

resource "aws_lb_target_group" "car_rental_service" {
  name        = "car-rental-service"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
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

resource "aws_lb_listener" "internet_facing" {
  load_balancer_arn = aws_lb.internet_facing.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.car_rental_service.arn
    type             = "forward"
  }
}
