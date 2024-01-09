// Define providers if needed
provider "aws" {
  region = var.aws_region
}

// Module references
module "ec2_module" {
  source = "./ec2"
}

module "api_gateway_module"{
  source = "./apigateway"
}

module "s3"{
  source = "./s3"
}
