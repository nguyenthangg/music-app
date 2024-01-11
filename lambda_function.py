import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    print(event)
    httpMethod = event['httpMethod']
    path = event['path']
    
    
    if httpMethod == 'GET' and path == '/health':
        return {
            'statusCode': 200,
            'body': json.dumps('File uploaded to S3 successfully')
        }
    elif httpMethod == 'GET' and path == '/example':
        return {
            'statusCode': 200,
            'body': json.dumps('resource is ready')
        }