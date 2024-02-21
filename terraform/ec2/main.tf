#----------------Create ssh key using ssh-keygen command---------------------------


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/../../ssh_key_aws.pub")
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
  user_data = <<-EOF
              #!/bin/bash
              yum install -y docker
              systemctl enable docker
              systemctl start docker
              sudo chown $USER /var/run/docker.sock
              docker run -p 80:80 -d nginx
              EOF

 connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = aws_key_pair.deployer.private_key_pem
    host        = self.public_ip
  }
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}