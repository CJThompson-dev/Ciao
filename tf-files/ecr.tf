resource "aws_ecr_repository" "ciao-proxy" {
  name                 = "ciao-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Owner = "Ciao"
  }
}