

resource "aws_ecs_task_definition" "car_rental_service" {
  family                   = "car-rental-service"
  execution_role_arn       = var.ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = templatefile(
    #  it just takes takes the data in the file and replaces the placeholders with the values from variables
    var.template_link,
    {
      app_image      = var.app_image
      app_port       = var.container_port
      fargate_cpu    = var.fargate_cpu
      fargate_memory = var.fargate_memory
      aws_region     = var.aws_region
    }
  )
}

resource "aws_ecs_service" "car_rental_service" {
  name            = "car-rental-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.car_rental_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "car-rental-service"
    container_port   = var.container_port
  }

  # depends_on = [module.public_alb]
}
