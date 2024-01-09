output "lambda_arn" {
  value = aws_lambda_function.lambda-file-upload-v2.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda-file-upload-v2.invoke_arn
}