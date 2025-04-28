import boto3
import json
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', endpoint_url='http://localhost:4566')
table = dynamodb.Table('Users')

def lambda_handler(event, context):
    try:
        action = event.get('httpMethod', '')
        user_id = event.get('pathParameters', {}).get('user_id', '')

        if action == 'GET':
            response = table.get_item(Key={'UserId': user_id})
            return {
                'statusCode': 200,
                'body': json.dumps(response.get('Item', {}))
            }
        elif action == 'POST':
            body = json.loads(event['body'])
            table.put_item(Item=body)
            return {
                'statusCode': 201,
                'body': json.dumps(body)
            }
        elif action == 'DELETE':
            table.delete_item(Key={'UserId': user_id})
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Deleted successfully'})
            }
        else:
            return {'statusCode': 400, 'body': json.dumps({'message': 'Invalid request'})}
    except ClientError as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}

