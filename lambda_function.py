import json
import boto3
from module_post import module_post

region = 'us-west-2'
dynamodb = boto3.resource('dynamodb', region_name=region)

# Replace 'YourDynamoDBTableName' with your actual DynamoDB table name
table_name = 'youtube-link'
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    
    print(event)
    httpMethod = event['httpMethod']
    path = event['path']
    print(path)

   
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
    
    elif httpMethod == 'POST' and path == '/yourlist':
        body = json.loads(event['body'])
        return(module_post(body))
    
    elif httpMethod == 'GET' and path == '/yourlist':
        try:
            # # Scan the DynamoDB table to get all items
            # response = table.scan()

            # # Extract items from the response
            # items = response.get('Items', [])

            # # Process and extract specific attributes
            # processed_items = []
            # for item in items:
            #     item_id = item.get('id')
            #     name = item.get('name')
            #     youtube_link = item.get('youtubeLink')

            #     # Your processing logic goes here
            #     # For example, you can create a dictionary with the specific attributes
            #     processed_item = {
            #         'id': item_id,
            #         'name': name,
            #         'youtubeLink': youtube_link
            #     }

            #     processed_items.append(processed_item)
            #     print("Processed Item:", processed_item)

            # return {
            #     'statusCode': 200,
            #     'body': json.dumps({'items': processed_items}),
            # }
            return {
                'statusCode': 200,
                'body': json.dumps({'items': 'done well'}),
            }

        except Exception as e:
            print("Error:", e)

        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal Server Error'}),
        }
        



