resource "aws_instance" "example" {
  ami           = var.aws_ami
  instance_type = var.instance_type

  tags = {
    Name = "example-instance"
  }
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}