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

  execution_role_arn = aws_iam_role.ciao_ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "proxy"
      image = "${aws_ecr_repository.ciao-proxy.repository_url}:latest"  

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

resource "aws_ecs_service" "proxy" {
  name            = "ciao-proxy-service"
  cluster         = aws_ecs_cluster.ciao_ecs_cluster.id
  task_definition = aws_ecs_task_definition.proxy.arn

  launch_type                        = "FARGATE"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200


  network_configuration {
    subnets = ["subnet-09ffb20c4da788637", "subnet-0e606c290592d4005"]

    security_groups = [
      aws_security_group.hosp_proxy.id
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.proxy.arn
    container_name   = "proxy"
    container_port   = 80
  }
}