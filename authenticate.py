import base64
import boto3
import json
import os
def authenticate():
    authorization_header = event.get('headers', {}).get('Authorization', '')
    
    if authorization_header.startswith('Basic '):
        # Decode Base64-encoded credentials
        credentials_base64 = authorization_header.split(' ')[1]
        credentials = base64.b64decode(credentials_base64).decode('utf-8')
        
        # Split username and password
        username, password = credentials.split(':')
        
        if not username or not password:
            return {"statusCode": 400, "body": json.dumps({"error": "Username and password are required."})}

    # Retrieve DynamoDB table name from environment variable
        dynamodb_table = "your_dynamodb_table_name"

    # Initialize DynamoDB client
        dynamodb = boto3.resource("dynamodb")
        table = dynamodb.Table(dynamodb_table)

        try:
        # Query DynamoDB for the user
            response = table.get_item(Key={"username": username})

        # Check if user exists
            if "Item" not in response:
                return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials."})}

        # Compare hashed passwords
            stored_password = response["Item"]["password"]
            if not compare_passwords(password, stored_password):
                return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials."})}

            return {"statusCode": 200, "body": json.dumps({"message": "Login successful."})}
        except Exception as e:
            return {"statusCode": 500, "body": json.dumps({"error": str(e)})}