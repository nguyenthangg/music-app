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
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
    EOF
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}