resource "aws_ecs_cluster" "car_rental" {
  name = "car-rental"
}

resource "aws_ecs_task_definition" "car_rental_service" {
  family                   = "car-rental-service"
  execution_role_arn       = module.iam.ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = templatefile(
    #  it just takes takes the data in the file and replaces the placeholders with the values from variables
    "./templates/ecs/car-rental-service-task-definition.json.tftpl",
    {
      app_image      = var.app_image
      app_port       = var.app_port
      fargate_cpu    = var.fargate_cpu
      fargate_memory = var.fargate_memory
      aws_region     = var.aws_region
    }
  )
}

resource "aws_ecs_service" "car_rental_service" {
  name            = "car-rental-service"
  cluster         = aws_ecs_cluster.car_rental.id
  task_definition = aws_ecs_task_definition.car_rental_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [module.security_groups_services["car_rental_service"].security_group_id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.car_rental_service.arn
    container_name   = "car-rental-service"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.internet_facing]
}
