resource "aws_ecs_cluster" "ciao_ecs_cluster" {
  name = "ciao_ecs_cluster"
  tags = {
    Owner = "Ciao"
  }
}

resource "aws_ecs_task_definition" "proxy" {
  family = "ciao-proxy"

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "proxy"
      image = "${aws_ecr_repository.proxy.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.proxy.name
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "proxy"
        }
      }
    }
  ])
}