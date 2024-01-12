
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
  output_path = "${path.module}/lambda/lambda_function.zip"  # Output path for the ZIP file

  source {
    content  = file("${path.module}/../../lambda_function.py")  # Relative path to lambda_function.py from the current working directory
    filename = "lambda_function.py"  # Name of the file within the ZIP
  }

  source {
    content  = file("${path.module}/../../module_post.py")  # Relative path to module_post.py from the current working directory
    filename = "module_post.py"
  }
}



resource "aws_lambda_function" "lambda-file-upload-v2" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name     = "lambda-file-upload-v2"
  role              = aws_iam_role.iam_for_lambda.arn
  handler           = "lambda_function.lambda_handler"
  architectures     = ["x86_64"]
  runtime           = "python3.11"
  filename          = data.archive_file.lambda_zip.output_path  # Use the output_path of the ZIP file

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  environment {
    variables = {
      foo = "bar"
    }
  }
}


# IAM Policy for DynamoDB access
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_dynamodb_policy"
  description = "Policy for Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:Query", "dynamodb:Scan"],
      Effect   = "Allow",
      Resource = var.dynamodb_arn
    }]
  })
}
# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.iam_for_lambda.name
}

