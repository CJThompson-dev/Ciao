I first went with this but this was spewing some errors its better to make a sg and then make sg rules as their own resources


resource "aws_security_group" "hosp_ec2" {
  name                   = "Upstream server security group Ciao"
  region                 = "eu-west-2"
  description = "Allows ingress via TCP and SSH from ALB"
  vpc_id = "vpc-080dbb0b7dc86503a"
  egress {
    protocol = "-1" # This means all protocols 
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress = [{
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.hosp_alb.id]
    }, {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.hosp_alb.id]
    }]
  tags = {
    Owner = "Coaches"
  }
  tags_all = {
    Owner = "Coaches"
  }
}