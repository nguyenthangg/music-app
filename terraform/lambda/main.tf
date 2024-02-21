
resource "aws_iam_role" "iam_for_lambda"{
  name = "iam_for_lambda"

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

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda_function.zip"
  output_path = "${path.module}/../../lambda_function.zip"
}



resource "aws_lambda_function" "lambda-file-upload-v2" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name     = "lambda-file-upload-v2"
  role              = aws_iam_role.iam_for_lambda.arn
  handler           = "lambda_function.lambda_handler"
  architectures     = ["x86_64"]
  runtime           = "python3.11"
  filename          = "${path.module}/../../lambda_function.zip"
  environment {
    variables = {
      foo = "bar"
    }
  }
}
