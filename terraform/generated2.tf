# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_lb_listener" "hosp" {
  alpn_policy                          = null
  certificate_arn                      = null
  load_balancer_arn                    = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:loadbalancer/app/lb-Ciao/d7fd2dde506cb7dd"
  port                                 = 80
  protocol                             = "HTTP"
  region                               = "eu-west-2"
  routing_http_response_server_enabled = true
  tags                                 = {}
  tags_all                             = {}
  default_action {
    order            = 1
    target_group_arn = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:targetgroup/lb-tg-Ciao/e37a9b3b5fd09c50"
    type             = "forward"
    forward {
      target_group {
        arn    = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:targetgroup/lb-tg-Ciao/e37a9b3b5fd09c50"
        weight = 1
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
  enable_deletion_protection                  = false
  enable_http2                                = true
  enable_prefix_for_ipv6_source_nat           = "off"
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
  region                                      = "eu-west-2"
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
    bucket  = ""
    enabled = false
    prefix  = null
  }
  connection_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
  health_check_logs {
    bucket  = ""
    enabled = false
    prefix  = null
  }
}
