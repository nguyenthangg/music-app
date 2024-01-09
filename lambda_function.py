import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Retrieve the file data from the API Gateway event
    file_content = event['body']  # Assumes the file content is passed in the request body

    # Define S3 bucket and file name
    # bucket_name = 'your-s3-bucket-name'
    # file_name = 'uploaded_file.ext'  # Define the file name and extension

    # # Upload the file to S3
    # s3.put_object(Body=file_content, Bucket=bucket_name, Key=file_name)

    return {
        'statusCode': 200,
        'body': json.dumps('File uploaded to S3 successfully')
    }