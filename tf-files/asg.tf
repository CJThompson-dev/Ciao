resource "aws_autoscaling_group" "hosp_proxy" {
  name                = "hosp-proxy-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = ["subnet-09ffb20c4da788637", "subnet-0e606c290592d4005"]
  health_check_type = "ELB"
  health_check_grace_period = 300

  target_group_arns = [aws_lb_target_group.proxy.arn]

  launch_template {
    id      = aws_launch_template.hosp_proxy.id
    version = "$Latest"
  }
}