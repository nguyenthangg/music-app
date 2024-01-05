// Define providers if needed
provider "aws" {
  region = var.aws_region
}

// Module references
module "ec2_module" {
  source = "./ec2"
}

module "lambda_module" {
  source = "./lambda"
}
resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "${var.project}-s3-backend"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}
data "aws_caller_identity" "current" {}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.s3_bucket.arn]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = [aws_dynamodb_table.dynamodb_table.arn]
  }
}
resource "aws_iam_policy" "policy" {
  name   = "${title(var.project)}S3BackendPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_role" "iam_role" {
  name = "${title(var.project)}S3BackendRole"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
        "AWS": ${jsonencode(local.principal_arns)}
      },
      "Effect": "Allow"
      }
    ]
  }
  EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "${var.project}-s3-backend"
  force_destroy = false

  tags = local.tags
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "kms_key" {
  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}

locals {
  tags = {
    project = var.project
  }
}

data "aws_region" "current" {}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.project}-s3-backend"

  resource_query {
    query = <<-JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "project",
            "Values": ["${var.project}"]
          }
        ]
      }
    JSON
  }
}

output "config" {
  value = {
    bucket         = aws_s3_bucket.s3_bucket.bucket
    region         = data.aws_region.current.name
    role_arn       = aws_iam_role.iam_role.arn
    dynamodb_table = aws_dynamodb_table.dynamodb_table.name
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-series-s3-backend"
    key            = "test-project"
    region         = "us-west-2"
    encrypt        = true
    role_arn       = "arn:aws:iam::<ACCOUNT_ID>:role/HpiS3BackendRole"
    dynamodb_table = "terraform-series-s3-backend"
  }
}

provider "aws" {
  region = "us-west-2"
}


output "public_ip" {
  value = aws_instance.server.public_ip
}




