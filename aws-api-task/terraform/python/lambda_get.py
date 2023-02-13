import json
import boto3

def lambda_handler(event, context):

    # create a DynamoDB client
    dynamodb = boto3.client('dynamodb')

    # specify the table name
    table_name = 'Users'
    
    # extract the hash key value from the path parameter
    hash_key = event['pathParameters']['user_id']


    # create a response object by calling the `query` method on the client
    response = dynamodb.query(
        TableName=table_name,
        KeyConditionExpression='user_id = :hkey',
        ExpressionAttributeValues={
            ':hkey': {
                'S': hash_key
            }
        }
    )

    # extract the items from the response
    items = response.get('Items', [])


    # return the items if there is an entry for the hash_key
    if items:
        return {
            'statusCode': 200,
            'body': json.dumps(items)
        }

    # return an error if there is no entry for the hash_key
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({'error 404': 'No entry found for the specified user_id.'})
        }