provider "aws" {
  region = "us-east-1" # You can change this to your closest region
}

# 1. Create a Security Group (Firewall)
resource "aws_security_group" "web_sg" {
  name        = "practice-web-sg"
  description = "Allow SSH and Web Traffic"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict this to your IP
  }

  ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Allows anyone on the internet to view port 80
}

  # React Frontend Access
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic (so Ubuntu can download Docker)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Create the Ubuntu EC2 Instance
resource "aws_instance" "devops_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS AMI ID for us-east-1 (Verify for your region)
  instance_type = "t3.micro"               # Free-tier eligible
  
  security_groups = [aws_security_group.web_sg.name]
  key_name        = "devops-practice-key" # Must match a key pair created in your AWS console

  # 3. User Data: Automatically install Docker & Docker Compose on startup
  user_data = <<-EOF
              #!/bin/bash
              # Update packages and install Docker directly from Ubuntu repos
              apt-get update -y
              apt-get install -y docker.io

              # Enable and start Docker service
              systemctl start docker
              systemctl enable docker

              # Pull and run the Nginx container
              docker run -d -p 80:80 --name my-web-app nginx
              EOF

  tags = {
    Name = "DevOps-Practice-Server"
  }
}

# Output the public IP so you know where to connect
output "instance_public_ip" {
  value       = aws_instance.devops_server.public_ip
  description = "The public IP address of the Ubuntu server"
}