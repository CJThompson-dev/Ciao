resource "aws_s3_bucket" "ciao-lb-logs" {
  bucket = "ciao-lb-logs-bucket"

  tags = {
    Owner        = "Ciao"
  }
}