terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.16"
            
        }
    }
}

provider "aws" {
    region  = "${var.myregion}"
    default_tags {
        tags = {
            Key = "Name"
            Value = "Task_Project"
        }   
    }     
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

# Creating IAM Role for lambda function
resource "aws_iam_role" "task_lambda_api_role" {
    name = "task_lambda_api_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.task_lambda_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#  Attaching custom microservices policy to task_lamba_role
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.task_lambda_api_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem",
                "dynamodb:Query"
            ],
            "Resource": "arn:aws:dynamodb:eu-central-1:${var.accountId}:table/*"   # check if you can improve on this later 
        }
    ]
  })
}


# Creating Lambda Function archive/zip file 
data "archive_file" "post_init" {
    type        = "zip"
    source_file  = "${path.module}/python/lambda_post.py"
    output_path = "${path.module}/lambda_post.zip"
}

# Creating Lambda function for Post method
resource "aws_lambda_function" "lambda_post" {
    filename      = "lambda_post.zip"    
    function_name = "lambda_post"
    role          = aws_iam_role.task_lambda_api_role.arn
    runtime       = "python3.8"
    handler       = "lambda_post.lambda_handler"  
    timeout       = 15
}

# Setting up a cloudwatch log group for the lambda function
resource "aws_cloudwatch_log_group" "lambda_post" {
  name = "/aws/lambda/${aws_lambda_function.lambda_post.function_name}"

  retention_in_days = 30
}

# Creating Lambda Function archive/zip file 
data "archive_file" "get_init" {
    type        = "zip"
    source_file  = "${path.module}/python/lambda_get.py"
    output_path = "${path.module}/lambda_get.zip"
}

# Creating Lambda function for Get method
resource "aws_lambda_function" "lambda_get" {
    filename      = "lambda_get.zip"   
    function_name = "lambda_get"
    role          = aws_iam_role.task_lambda_api_role.arn
    runtime       = "python3.8"
    handler       = "lambda_get.lambda_handler"  
    timeout       = 15
}

# Setting up a cloudwatch log group for the lambda function
resource "aws_cloudwatch_log_group" "lambda_get" {
  name = "/aws/lambda/${aws_lambda_function.lambda_get.function_name}"
  retention_in_days = 30
}

# Creating API 
resource "aws_api_gateway_rest_api" "task_api_gw" {
  name = "task_api_gw"
  description = "Proxy to handle requests to our API"
}

# API gateway log groups
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_api_gateway_rest_api.task_api_gw.name}"
  retention_in_days = 30
}

# Creating POST methods 
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.task_api_gw.id
  resource_id   = aws_api_gateway_rest_api.task_api_gw.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

# lambda integration resource
resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.task_api_gw.id
  resource_id             = aws_api_gateway_rest_api.task_api_gw.root_resource_id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"  # Because lambda is invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_post.invoke_arn
}

# Lambda permissions for lambda_post
resource "aws_lambda_permission" "api_gw_lambda_post" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_post.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.task_api_gw.execution_arn}/${aws_api_gateway_deployment.apideploy.stage_name}/${aws_api_gateway_method.post_method.http_method}/*"
}

# Creating resource
resource "aws_api_gateway_resource" "sub_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.task_api_gw.id}"
  parent_id   = "${aws_api_gateway_rest_api.task_api_gw.root_resource_id}"
  path_part   = "{user_id}"  # Potential error 
}


# Creating GET methods 
resource "aws_api_gateway_method" "get_method" { 
  rest_api_id   = "${aws_api_gateway_rest_api.task_api_gw.id}"
  resource_id   = "${aws_api_gateway_resource.sub_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.task_api_gw.id}"
  resource_id = "${aws_api_gateway_resource.sub_resource.id}"
  http_method = "${aws_api_gateway_method.get_method.http_method}"
  integration_http_method = "POST"  # Because lambda is invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_get.invoke_arn
}


# Lambda permissions for lambda_get
resource "aws_lambda_permission" "api_gw_lambda_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.task_api_gw.execution_arn}/${aws_api_gateway_deployment.apideploy.stage_name}/${aws_api_gateway_method.get_method.http_method}/${aws_api_gateway_resource.sub_resource.path_part}"
}


resource "aws_api_gateway_deployment" "apideploy" {
  depends_on = [
    aws_api_gateway_integration.get_integration,
    aws_api_gateway_integration.post_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.task_api_gw.id
  stage_name  = "dev"
}

output "api_url" {
  description = "Deployment invoke url"
  value = aws_api_gateway_deployment.apideploy.invoke_url
}