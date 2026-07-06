provider "aws" {
  region = "eu-west-2"
}

import {
  to = aws_lb_target_group.hosp
  id = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:targetgroup/lb-tg-Ciao/e37a9b3b5fd09c50"
}
