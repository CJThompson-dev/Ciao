resource "aws_launch_template" "hosp_proxy" {
  name_prefix   = "hosp-proxy-"
  image_id      = "ami-0b45ae66668865cd6"  # basic ubuntu
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.hosp_proxy.id]

  user_data = filebase64("${path.module}/user-data.sh") # fix this

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = "hosp-proxy-ciao"
      Owner = "Students"
    }
  }
}