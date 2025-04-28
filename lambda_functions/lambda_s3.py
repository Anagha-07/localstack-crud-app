import boto3
import json
from botocore.exceptions import ClientError

s3 = boto3.client('s3', endpoint_url='http://localhost:4566')

def lambda_handler(event, context):
    try:
        bucket_name = 'my-bucket'
        file_name = event['pathParameters']['file_name']
        file_content = event['body']
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'File uploaded successfully'})
        }
    except ClientError as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}

