resource "aws_security_group" "hosp_alb" {
  name        = "Load Balancer Security Group Ciao"
  description = "Allows ingress via TCP on port 80 from all sources."
  vpc_id      = "vpc-080dbb0b7dc86503a"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "Students"
  }
}

resource "aws_security_group" "hosp_proxy" {
  name        = "Proxy Security Group Ciao"
  description = "Allows ingress from ALB only, egress to HOSP"
  vpc_id      = "vpc-080dbb0b7dc86503a"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "Students"
  }
}

resource "aws_security_group_rule" "alb_egress_to_proxy" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.hosp_alb.id
  source_security_group_id = aws_security_group.hosp_proxy.id
}

resource "aws_security_group_rule" "proxy_ingress_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.hosp_proxy.id
  source_security_group_id = aws_security_group.hosp_alb.id
}