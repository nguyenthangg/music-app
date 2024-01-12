// Define providers if needed
provider "aws" {
  region = var.aws_region
}
module "dynamodb"{
  source = "./dynamodb"
}
// Module references
module "ec2_module" {
  source = "./ec2"
}
module "lambda" {
  source = "./lambda"  # Path to your Lambda module
  dynamodb_arn = module.dynamodb.dynamodb_arn
}

module "api_gateway"{
  source = "./apigateway"
  lambda_arn = module.lambda.lambda_arn
  invoke_arn = module.lambda.invoke_arn
}

module "s3"{
  source = "./s3"

}

