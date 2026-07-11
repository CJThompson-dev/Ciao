# The main queue - holds writes waiting to reach HOSP
resource "aws_sqs_queue" "hosp_writes" {
  name = "ciao-hosp-writes"

  # How long a worker has to process a message before it
  # becomes visible again for retry. Set longer than HOSP's
  # worst timeout (~30s) so we don't retry while still trying.
  visibility_timeout_seconds = 60

  # Keep messages up to 4 days if HOSP stays down
  message_retention_seconds = 345600

  # Send messages that fail repeatedly to a dead-letter queue
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.hosp_writes_dlq.arn
    maxReceiveCount     = 5
  })
}

# Dead-letter queue - writes that failed 5 times land here
# so they're not lost and can be investigated
resource "aws_sqs_queue" "hosp_writes_dlq" {
  name                      = "ciao-hosp-writes-dlq"
  message_retention_seconds = 1209600 # 14 days
}

output "hosp_writes_queue_url" {
  value = aws_sqs_queue.hosp_writes.url
}
output "hosp_writes_queue_arn" {
  value = aws_sqs_queue.hosp_writes.arn
}
