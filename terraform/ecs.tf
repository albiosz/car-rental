resource "aws_ecs_cluster" "main" {
  name = "cb-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "cb-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
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

resource "aws_ecs_service" "cb-service" {
  name            = "cb-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "car-rental-service"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.name, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}
