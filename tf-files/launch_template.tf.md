resource "aws_launch_template" "hosp_proxy" {
  name_prefix   = "hosp-proxy-"
  image_id      = "ami-0b45ae66668865cd6"  # Ubuntu 22.04 eu-west-2
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_proxy.name
  }

  vpc_security_group_ids = [aws_security_group.hosp_proxy.id]

  user_data = filebase64("${path.module}/user-data.sh")

}
