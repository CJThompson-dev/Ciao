resource "aws_autoscaling_group" "hosp_proxy" {
  name                = "hosp-proxy-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = ["subnet-09ffb20c4da788637", "subnet-0e606c290592d4005"]
  health_check_type   = "ELB"

  target_group_arns = [aws_lb_target_group.hosp.arn]

  launch_template {
    id      = aws_launch_template.hosp_proxy.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "hosp-proxy-ciao"
    propagate_at_launch = true #this allows the instances to be tagged by asg
  }
}