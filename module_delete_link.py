import boto3
import json

region = 'us-west-2'
dynamodb = boto3.resource('dynamodb', region_name=region)

# Replace 'YourDynamoDBTableName' with your actual DynamoDB table name
table_name = 'youtube-link'
table = dynamodb.Table(table_name)

def module_delete_link(body):
    return {
            'statusCode': 200,
            'body': json.dumps('resource is ready')
        }