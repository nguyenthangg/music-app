output "lambda_arn" {
  value = aws_lambda_function.lambda-file-upload-v2.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda-file-upload-v2.invoke_arn
}

output "lambda_role_name" {
  value = aws_iam_role.iam_for_lambda.name
}