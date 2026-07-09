resource "aws_ecr_repository" "ciao-ecr" {
  name                 = "ciao-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}