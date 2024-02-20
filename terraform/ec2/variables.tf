variable "aws_ami" {
  description = "AMI for EC2 instance"
  default     = "ami-008fe2fc65df48dac"  # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"  # Change instance type if needed
}

variable "public_key" {
  description = "The key name for the EC2 instances"
}
variable "private_key" {
  description = "The key name for the EC2 instances"
}
variable "key_name" {
  description = "The key name for the EC2 instances"
}