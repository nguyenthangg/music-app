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
