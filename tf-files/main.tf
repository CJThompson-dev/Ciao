terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

import {
  to = aws_lb_target_group.hosp
  id = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:targetgroup/lb-tg-Ciao/e37a9b3b5fd09c50"
}

import {
  to = aws_lb.hosp
  id = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:loadbalancer/app/lb-Ciao/d7fd2dde506cb7dd"
}

import {
  to = aws_lb_listener.hosp
  id = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:listener/app/lb-Ciao/d7fd2dde506cb7dd/16c87ab4c291b355"
}

terraform {
  backend "s3" {
    bucket       = "ciao-tf-backend"
    key          = "hosp-infra/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}