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
      minimum_healthy_targets_count      = 2
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 2
      minimum_healthy_targets_percentage = "off"
    }
  }
}


resource "aws_lb_listener" "hosp" {
  alpn_policy                          = null
  certificate_arn                      = null
  load_balancer_arn                    = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:loadbalancer/app/lb-Ciao/d7fd2dde506cb7dd"
  port                                 = 80
  protocol                             = "HTTP"
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

resource "aws_security_group" "hosp_alb" {
  name        = "Load Balancer Security Group Ciao"
  region      = "eu-west-2"
  description = "Allows ingress via TCP on port 80 from all sources."
  vpc_id      = "vpc-080dbb0b7dc86503a"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 80
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
  }]
  tags = {
    Owner = "Students"
  }
}


resource "aws_security_group" "hosp_ec2" {
  name        = "Upstream server security group Ciao"
  description = "Allows ingress via TCP on port 80 from ALB only"
  vpc_id      = "vpc-080dbb0b7dc86503a"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.hosp_alb.id] # only from ALB
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.hosp_alb.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "hosp" {
  ami                                  = "ami-03c24c0dc17d1ba36"
  associate_public_ip_address          = true
  availability_zone                    = "eu-west-2b"
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = "ben"
  monitoring                           = true
  region                               = "eu-west-2"
  source_dest_check                    = true
  subnet_id                            = "subnet-0e606c290592d4005"
  tags = {
    Name  = "HOSP Server Ciao"
    Owner = "Coaches"
  }
  tags_all = {
    Name  = "HOSP Server Ciao"
    Owner = "Coaches"
  }
  tenancy                = "default"
  user_data              = "#!/bin/bash\n# Update and install Python 3.9+\nsudo apt-get update -y\nsudo apt-get install -y python3.9\n"
  vpc_security_group_ids = [aws_security_group.hosp_ec2.id]
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 100
    tags                  = {}
    tags_all              = {}
    throughput            = 0
    volume_size           = 8
    volume_type           = "gp2"
  }
}

resource "aws_launch_template" "hosp" {
  name_prefix            = "hosp-"
  image_id               = "ami-03c24c0dc17d1ba36"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.hosp_ec2.id]
}

resource "aws_autoscaling_group" "hosp" {
  name                = "hosp-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = ["subnet-09ffb20c4da788637", "subnet-0e606c290592d4005"]
  # I was going to use AZs here but apparently this is a better way to be exact
  # It has a very similar to AZs but pulls exact subnets from our elb
  target_group_arns = [aws_lb_target_group.hosp.arn]
  launch_template {
    id      = aws_launch_template.hosp.id
    version = "$Latest"
  }
}