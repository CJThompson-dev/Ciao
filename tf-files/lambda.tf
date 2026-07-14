resource "aws_lambda_function" "retry_posts" {
  function_name = "ciao-retry-posts"
  role          = aws_iam_role.lambda_retry.arn
  handler       = "ciao_handler.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30

  environment {
    variables = {
      HOSP_URL = "http://lb-ciao-652963539.eu-west-2.elb.amazonaws.com"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.hosp_writes.arn
  function_name    = aws_lambda_function.retry_posts.arn
  batch_size       = 1
}