resource "aws_iam_role" "lambda-role-file-resize"{
  name = "lambda-file-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
      },
    ]
  })
  managed_policy_arns = var.lambda_policy
}
resource "aws_lambda_function" "lambda-file-upload-v2" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name     = "lambda-file-upload-v2"
  role              = aws_iam_role.lambda-role-file-resize.arn
  handler           = "lambda_function.lambda_handler"
  architectures     = ["x86_64"]
  runtime           = "python3.11"
  filename          = "lambda_function.zip"
#   source_code_hash = data.archive_file.lambda.output_base64sha256
  environment {
    variables = {
      foo = "bar"
    }
  }
}

# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda-file-upload-v2.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "${aws_api_gateway_rest_api.api-file.execution_arn}/*"
# }