import boto3
import json
from pytube import YouTube
region = 'us-west-2'
dynamodb = boto3.resource('dynamodb', region_name=region)

# Replace 'YourDynamoDBTableName' with your actual DynamoDB table name
table_name = 'youtube-link'
table = dynamodb.Table(table_name)

def module_post(body):
    link = body.get('youtubeLink')
    name = scrape_info(link)

    try:
        id = str(body.get('id'))
        youtube_link = body.get('youtubeLink')

        # logic with id, name, and youtube_link goes here
        # For example, you can print them or perform some operations

        print("Received id:", id)
        print("Received name:", name)
        print("Received YouTube link:", youtube_link)
        
        response = table.put_item(Item={'id': id, 'name': name, 'youtubeLink': youtube_link})

        print("Item added to DynamoDB successfully:", response)

    #     # Returning a response (this is just an example)
        return {
                "statusCode": 200,
                "body": json.dumps('Insert Sucessfull')
            }
    except Exception as e:
        print("Error adding item to DynamoDB:", e)

        return {
            'statusCode': 500,
            'body': 'Error adding item to DynamoDB',
        }

def scrape_info(url): 
    try:
        yt = YouTube(url)
        title = yt.title
        return title
    except Exception as e:
        print(f"Error: {e}")
        return None