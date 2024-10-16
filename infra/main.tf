provider "aws" {
  region = "sa-east-1"
}

resource "aws_security_group" "securitygroup" {
  name        = "ec2-securitygroup"
  description = "Allow HTTP, custom app ports, and SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
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
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "terraform-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.small"  # Changed to t2.small to handle multiple containers
  key_name      = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.securitygroup.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user

              # Create Docker network
              docker network create app-network

              # Run MySQL container
              docker run -d --name mysql \
                --network app-network \
                -e MYSQL_ROOT_PASSWORD=root \
                -e MYSQL_DATABASE=task_db \
                -p 3306:3306 \
                mysql:8.0

              # Wait for MySQL to initialize
              sleep 30

              # Run backend container
              docker run -d --name task-back \
                --network app-network \
                -e SPRING_PROFILES_ACTIVE=dev \
                -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/task_db \
                -p 8080:8080 \
                mathfrancisco/todolist-backend:latest

              # Run frontend container
              docker run -d --name task-front \
                --network app-network \
                -p 80:80 \
                mathfrancisco/todolist-frontend:latest
              EOF
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
