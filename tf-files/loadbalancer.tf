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
  slow_start                         = 0
  tags                               = {}
  tags_all                           = {}
  target_type                        = "instance"
  vpc_id                             = "vpc-080dbb0b7dc86503a"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 3
  }
  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

resource "aws_lb_target_group" "proxy" {
  deregistration_delay               = "300"
  ip_address_type                    = "ipv4"
  lambda_multi_value_headers_enabled = null
  load_balancing_algorithm_type      = "round_robin"
  load_balancing_anomaly_mitigation  = "off"
  load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
  name                               = "lb-tg-Ciao-proxy"
  port                               = 80
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  slow_start                         = 0
  tags                               = {}
  tags_all                           = {}
  target_type                        = "ip"
  vpc_id                             = "vpc-080dbb0b7dc86503a"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 3
  }
  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

resource "aws_lb_listener" "hosp" {
  alpn_policy                          = null
  certificate_arn                      = null
  load_balancer_arn                    = aws_lb.hosp.arn
  port                                 = 80
  protocol                             = "HTTP"
  routing_http_response_server_enabled = true

  default_action {
    order = 1
    type  = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.hosp.arn
        weight = 50
      }
      target_group {
        arn    = aws_lb_target_group.proxy.arn
        weight = 50
      }
    }
  }
}


# __generated__ by Terraform
resource "aws_lb" "hosp" {
  client_keep_alive                           = 3600
  customer_owned_ipv4_pool                    = null
  desync_mitigation_mode                      = "defensive"
  dns_record_client_routing_policy            = null
  drop_invalid_header_fields                  = false
  enable_cross_zone_load_balancing            = true
  enable_deletion_protection                  = true
  enable_http2                                = true
  enable_tls_version_and_cipher_suite_headers = false
  enable_waf_fail_open                        = false
  enable_xff_client_port                      = false
  enable_zonal_shift                          = false
  idle_timeout                                = 60
  internal                                    = false
  ip_address_type                             = "ipv4"
  load_balancer_type                          = "application"
  name                                        = "lb-Ciao"
  preserve_host_header                        = false
  security_groups                             = ["sg-04874a6f374d17bf6"]
  subnets                                     = ["subnet-09ffb20c4da788637", "subnet-0e606c290592d4005"]
  tags = {
    Owner = "Students"
  }
  tags_all = {
    Owner = "Students"
  }
  xff_header_processing_mode = "append"
  access_logs {
    bucket  = aws_s3_bucket.ciao-lb-logs.bucket
    enabled = true
    prefix  = "hosp-lb-access-logs"
  }
  connection_logs {
    bucket  = aws_s3_bucket.ciao-lb-logs.bucket
    enabled = true
    prefix  = "hosp-lb-connection-logs"
  }
  health_check_logs {
    bucket  = aws_s3_bucket.ciao-lb-logs.bucket
    enabled = true
    prefix  = "hosp-lb-health-check-logs"
  }
}


resource "aws_s3_bucket" "ciao-lb-logs" {
  bucket = "ciao-lb-logs-bucket"

  tags = {
    Owner = "Ciao"
  }
}

resource "aws_athena_database" "ciao_athena_table" {
  name   = "ciao_athena_table"
  bucket = aws_s3_bucket.ciao-lb-logs.id
}

resource "aws_athena_workgroup" "ciao" {
  name = "ciao-workgroup"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.ciao-lb-logs.bucket}/athena-results/"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = aws_s3_bucket.ciao-lb-logs.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowALBAccess",
        Effect = "Allow",
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.ciao-lb-logs.bucket}/*"
      }
    ]
  })
}

