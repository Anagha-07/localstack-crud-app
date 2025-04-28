#!/bin/bash

# Set LocalStack endpoint and region
ENDPOINT="http://localhost:4566"
REGION="us-east-1"

echo "Checking DynamoDB Tables..."
# Check DynamoDB tables
aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl dynamodb list-tables

# If 'Users' table does not exist, create it
if [ "$(aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl dynamodb list-tables | grep 'Users')" == "" ]; then
  echo "Table 'Users' not found. Creating DynamoDB table..."
  aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl dynamodb create-table \
    --table-name Users \
    --attribute-definitions AttributeName=UserId,AttributeType=S \
    --key-schema AttributeName=UserId,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
fi

echo "Checking S3 Buckets..."
# Check for the S3 bucket
aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl s3 ls

# If 'my-bucket' does not exist, create it
if [ "$(aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl s3 ls | grep 'my-bucket')" == "" ]; then
  echo "Bucket 'my-bucket' not found. Creating S3 bucket..."
  aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl s3 mb s3://my-bucket
fi

echo "Checking Lambda Functions..."
# Check for deployed Lambda functions
aws --endpoint-url=$ENDPOINT --region $REGION --no-verify-ssl lambda list-functions

# Optional: Here you can add logic to deploy the Lambda functions if they are not found

echo "All checks completed."

