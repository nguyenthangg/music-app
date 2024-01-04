variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"  # Replace with your desired region
}

variable "aws_ami" {
  description = "AMI for EC2 instance"
  default     = "ami-008fe2fc65df48dac"  # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"  # Change instance type if needed
}
