# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_lb_target_group" "hosp" {
  deregistration_delay               = "300"
  ip_address_type                    = "ipv4"
  lambda_multi_value_headers_enabled = null
  load_balancing_algorithm_type      = "round_robin"
  load_balancing_anomaly_mitigation  = "off"
  load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
  name                               = "lb-tg-Ciao"
  port                               = 80
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  proxy_protocol_v2                  = null
  region                             = "eu-west-2"
  slow_start                         = 0
  tags                               = {}
  tags_all                           = {}
  target_type                        = "instance"
  vpc_id                             = "vpc-080dbb0b7dc86503a"
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}
