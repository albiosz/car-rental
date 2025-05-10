
resource "aws_cloudwatch_log_group" "car_rental_service" {
  name              = "/ecs/car-rental-service"
  retention_in_days = 30

  tags = {
    name = "car-rental-service"
  }
}

resource "aws_cloudwatch_log_stream" "car_rental_service" {
  name           = "car-rental-service"
  log_group_name = aws_cloudwatch_log_group.car_rental_service.name
}
