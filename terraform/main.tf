provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = "t2.micro"     # Change instance type if needed

  tags = {
    Name = "example-instance"
  }
}
