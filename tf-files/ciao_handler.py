# Used to read and write JSON data
import json

# Used to read environment variables
import os

# Used to send HTTP requests to the HOSP API
import requests

# AWS Lambda logging library
import logging



# Create a logger for CloudWatch Logs
logger = logging.getLogger()

# Record informational messages, warnings and errors
logger.setLevel(logging.INFO)



# Base URL of the HOSP API.
# Read from a Lambda Environment Variable so it can be
# changed without modifying the code.
HOSP_BASE_URL = os.environ.get(
    "HOSP_BASE_URL",
    "http://hosp"
)



# Main function that AWS Lambda runs automatically
# whenever a new SQS message arrives.
def lambda_handler(event, context):

    # Record that Lambda has started.
    logger.info("Lambda function started.")

    # Record the full SQS event for troubleshooting.
    logger.info(json.dumps(event))

    # Loop through every message received from SQS.
    for record in event["Records"]:

        # Convert the JSON message stored in SQS into
        # a normal Python dictionary.
        message = json.loads(record["body"])

        # Read the HTTP method (POST, PUT or PATCH)
        # from the SQS message.
        method = message["method"]

        # Read the API endpoint to call.
        path = message["path"]

        # Read any HTTP headers that should be sent.
        headers = message["headers"]

        # Read the JSON payload that must be sent to HOSP.
        body = message["body"]

        # Build the full HOSP URL by combining the base
        # address with the API endpoint.
        url = f"{HOSP_BASE_URL}{path}"

        # Add a User-Agent header if one does not exist.
        # This helps identify Lambda requests in logs.
        headers.setdefault("User-Agent", "ciao-lambda")

        # Record the request being sent.
        logger.info(f"Sending {method} request to {url}")

        # Try sending the request to the HOSP API.
        try:

            # Send the HTTP request using the values
            # read from the SQS message.
            response = requests.request(
                method=method,
                url=url,
                headers=headers,
                json=body,
                timeout=30
            )

            # Record the HTTP status code returned by HOSP.
            logger.info(f"HOSP returned {response.status_code}")

            # Retry only if HOSP has a server-side problem.
            # Client errors (4xx) are not retried because
            # sending the same request again will not fix them.
            if response.status_code >= 500:
                raise Exception(
                    f"HOSP returned server error {response.status_code}"
                )

        # Handle any errors while communicating with HOSP.
        except Exception as error:

            # Record the error in CloudWatch Logs.
            logger.error(str(error))

            # Raise the exception again.
            # Lambda reports the invocation as failed.
            # SQS keeps the message and retries it.
            # After 5 failed attempts, SQS automatically
            # moves the message to the Dead Letter Queue.
            raise

    # Every SQS message was processed successfully.
    return {
        "statusCode": 200,
        "body": json.dumps(
            "All queued messages processed successfully."
        )
    }