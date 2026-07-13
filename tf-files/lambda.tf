resource "aws_lambda_function" "retry_posts" {
  function_name = "ciao-retry-posts"
  role          = aws_iam_role.lambda_retry.arn
  handler       = "lambda_handler.py"
  runtime       = "python3.14"
  timeout       = 30

  environment {
    variables = {
      HOSP_URL = "http://lb-ciao-652963539.eu-west-2.elb.amazonaws.com:80"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.failed_posts.arn
  function_name    = aws_lambda_function.retry_posts.arn
  batch_size       = 1
}