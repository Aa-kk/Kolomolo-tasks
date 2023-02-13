import boto3
import uuid
import json

def lambda_handler(event, context):
    
    # Extract the request body
    request_body = json.loads(event['body'])
    name = request_body['firstname']
    age = str(request_body['age'])
    
    # create a DynamoDB client
    dynamodb = boto3.client('dynamodb')

    # specify the table name
    table_name = 'Users'

    # creating GUID
    id = str(uuid.uuid4())
    
    # specify the item to be added
    item = {
        'user_id': {
            'S': id
        },
        'firstname': {
            'S': name
        },
        'age': {
            'N': age
        }
}

    # create a response object by calling the `put_item` method on the client
    response = dynamodb.put_item(
        TableName=table_name,
        Item=item
    )

    # Return uuid as response
    return { 
        'statusCode': 200,
        'body': json.dumps("Added Entry with user_id: " + id + " Successfully!")
    }



