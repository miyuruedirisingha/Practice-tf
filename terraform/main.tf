provider "aws" {
  region = "us-east-1"
}

# 1. Security Group
resource "aws_security_group" "web_sg" {
  name        = "practice-web-sg"
  description = "Allow SSH and Web Traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. EC2 Instance
resource "aws_instance" "devops_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name                = "devops-practice-key"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io docker-compose-plugin git

              systemctl start docker
              systemctl enable docker

              git clone https://github.com/miyuruedirisingha/Practice-tf.git /home/ubuntu/app
              cd /home/ubuntu/app
              docker compose up -d --build
              EOF

  tags = {
    Name = "DevOps-Practice-Server"
  }
}

output "instance_public_ip" {
  value       = aws_instance.devops_server.public_ip
  description = "The public IP address of the Ubuntu server"
}