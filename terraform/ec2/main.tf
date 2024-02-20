#----------------Create ssh key using ssh-keygen command---------------------------


resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
  }

# ssh-keygen # name = ssh_key_aws
# chmod 400 ssh_key_aws
# cat ssh_key_aws >> GitHub Secrets EC2_PRIVATE_SSH_KEY
# cat ssh_key_aws.pub >> GitHub Secrets EC2_PUBLIC_SSH_KEY

resource "aws_instance" "example" {
  ami           = var.aws_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  tags = {
    Name = "example-instance"
  }

 connection {
    type        = "ssh"
    user        = "ec2-user"  # Update with your EC2 instance username
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}
output "instance_public_ip" {
  value = aws_instance.example.public_ip
  sensitive = true
  
}