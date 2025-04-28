# LocalStack CRUD Application

This project demonstrates a **CRUD application** using **LocalStack** to simulate AWS services locally. It uses **Lambda functions** to perform operations on **DynamoDB** and **S3**, allowing you to develop and test serverless applications without needing an actual AWS account.

---

## 🚀 Features

- **Lambda Functions** for CRUD operations on DynamoDB and file uploads to S3.
- **DynamoDB** for storing user data.
- **S3** for storing uploaded files.
- All AWS services simulated locally via **LocalStack**.

---

## 🧰 Prerequisites

- [Docker](https://www.docker.com/)
- [AWS CLI](https://aws.amazon.com/cli/)
- Python 3.x
- [`awslocal` (awscli-local)](https://github.com/localstack/awscli-local) – Optional but useful.

---

## ⚙️ Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository_url>
cd localstack-crud-app
```

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Start LocalStack with Docker

```bash
docker-compose -f docker/docker-compose.yml up
```

> This starts LocalStack services on `http://localhost:4566`.

---

## 🏗️ Set Up AWS Resources Locally

### ✅ Create DynamoDB Table

```bash
aws --endpoint-url=http://localhost:4566 dynamodb create-table \
  --table-name Users \
  --attribute-definitions AttributeName=UserId,AttributeType=S \
  --key-schema AttributeName=UserId,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

### ✅ Create S3 Bucket

```bash
aws --endpoint-url=http://localhost:4566 s3 mb s3://my-bucket
```

---

## 🧪 Test Lambda Functions

> Ensure Lambda functions (`lambda_dynamodb`, `lambda_s3`) are deployed to LocalStack. If not, deploy them manually or request setup instructions.

### 🔄 Test DynamoDB Lambda Function

#### ➤ Create (POST)

```bash
aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name lambda_dynamodb \
  --payload '{"httpMethod": "POST", "body": "{\"UserId\": \"123\", \"Name\": \"John Doe\", \"Age\": 30}"}' \
  output.json
cat output.json
```

#### ➤ Read (GET)

```bash
aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name lambda_dynamodb \
  --payload '{"httpMethod": "GET", "pathParameters": {"user_id": "123"}}' \
  output.json
cat output.json
```

#### ➤ Delete (DELETE)

```bash
aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name lambda_dynamodb \
  --payload '{"httpMethod": "DELETE", "pathParameters": {"user_id": "123"}}' \
  output.json
cat output.json
```

---

### 🗂️ Test S3 Lambda Function

```bash
aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name lambda_s3 \
  --payload '{"pathParameters": {"file_name": "test.txt"}, "body": "This is a test file."}' \
  output.json
cat output.json
```

Check the uploaded file:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket
```

---

## 🧪 Run `script.sh` for Status Checks

To verify that your DynamoDB tables, S3 buckets, and Lambda functions are set up correctly, you can run the provided `script.sh`.

This script will check the following:

- DynamoDB tables.
- S3 buckets.
- Lambda functions deployed to LocalStack.

Run the script with the following command:

```bash
./script.sh
```

Example output:

```bash
Checking DynamoDB Tables...
{
    "TableNames": [
        "Users"
    ]
}
Checking S3 Buckets...
2025-04-28 19:05:00 my-bucket
Checking Lambda Functions...
{
    "Functions": []
}
All checks completed.
```

---

## 🧹 Clean Up

Stop LocalStack:

```bash
docker-compose down
```

---

## 📁 Project Structure

```
/localstack-crud-app
├── /lambda_functions
│   ├── lambda_dynamodb.py
│   ├── lambda_s3.py
├── /docker
│   ├── docker-compose.yml
├── README.md
├── requirements.txt
├── .gitignore
├── script.sh   
```

---

## 📌 Notes

- All services (Lambda, DynamoDB, S3) are simulated locally.
- No AWS credentials or account is required.
- Use this setup for testing and development before deploying to the real AWS environment.
