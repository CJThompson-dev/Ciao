resource "aws_cloudwatch_log_group" "proxy" {
  name              = "/ecs/ciao-proxy"
  retention_in_days = 30
}