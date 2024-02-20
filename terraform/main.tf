// Define providers if needed
provider "aws" {
  region = var.aws_region
}

module "dynamodb"{
  source = "./dynamodb"
  lambda_role_name = module.lambda.lambda_role_name
}
// Module references
module "ec2_module" {
  source = "./ec2"
  key_name_ = var.key_name
  public_key_ = var.public_key
  private_key_ = var.private_key
}

module "lambda" {
  source = "./lambda"  # Path to your Lambda module
}

module "api_gateway"{
  source = "./apigateway"
  lambda_arn = module.lambda.lambda_arn
  invoke_arn = module.lambda.invoke_arn
}

module "s3"{
  source = "./s3"

}

