
resource "aws_api_gateway_rest_api" "example_api_gateway" {
  name        = "example_api_gateway"
  description = "Example API Gateway"
  # Other API Gateway configurations...
   endpoint_configuration {
    types = ["REGIONAL"]
    }
}

resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.example_api_gateway.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id   = aws_api_gateway_resource.example_resource.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id             = aws_api_gateway_resource.example_resource.id
  http_method             = aws_api_gateway_method.example_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = var.invoke_arn# Use the Lambda ARN output from the lambda module
}

#####################Health resouce###################################
resource "aws_api_gateway_resource" "health_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.example_api_gateway.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "get_health_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id   = aws_api_gateway_resource.health_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "health_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id             = aws_api_gateway_resource.health_resource.id
  http_method             = aws_api_gateway_method.get_health_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}

######################LIST RESOURCE#######################################################
resource "aws_api_gateway_resource" "yourlist_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.example_api_gateway.root_resource_id
  path_part   = "yourlist"
}
################################POST
resource "aws_api_gateway_method" "yourlist_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id   = aws_api_gateway_resource.yourlist_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "yourlist_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id             = aws_api_gateway_resource.yourlist_resource.id
  http_method             = aws_api_gateway_method.yourlist_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}
###############################GET
resource "aws_api_gateway_method" "yourlist_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id   = aws_api_gateway_resource.yourlist_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "yourlist_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api_gateway.id
  resource_id             = aws_api_gateway_resource.yourlist_resource.id
  http_method             = aws_api_gateway_method.yourlist_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}

##########################################################################################
resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on    = [aws_api_gateway_integration.health_integration,
                  aws_api_gateway_integration.example_integration,
                  aws_api_gateway_integration.yourlist_get_integration,
                  aws_api_gateway_integration.yourlist_post_integration]

  rest_api_id   = aws_api_gateway_rest_api.example_api_gateway.id
  # Replace with your desired stage name
}
resource "aws_api_gateway_stage" "stageing" {
  deployment_id = aws_api_gateway_deployment.example_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.example_api_gateway.id
  stage_name    = "prod"
}
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn = aws_api_gateway_deployment.example_deployment.execution_arn
}
