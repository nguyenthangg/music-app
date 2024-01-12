
variable "lambda_policy" {
  description = "lambda role"
  default     = ["arn:aws:iam::aws:policy/CloudWatchFullAccess","arn:aws:iam::aws:policy/AmazonS3FullAccess","arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"]  
  # Replace with your desired AMI ID
}

variable "dynamodb_arn" {
  description = "ARN of the dynamodb table"
  type        = string
}