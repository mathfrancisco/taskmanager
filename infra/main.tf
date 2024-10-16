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
  ami           = "ami-0c101f26f147fa7fd"  # Verifique se esse AMI está disponível em sa-east-1
  instance_type = "t3.micro"
  key_name      = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.securitygroup.id]
  
  # Habilitar monitoramento detalhado (opcional, mas útil para acompanhar o uso de recursos)
  monitoring = true

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user

              # Create Docker network
              docker network create app-network

              # Run MySQL container with memory limits
              docker run -d --name mysql \
                --network app-network \
                -e MYSQL_ROOT_PASSWORD=root \
                -e MYSQL_DATABASE=task_db \
                -p 3306:3306 \
                --memory=256m \
                mysql:8.0

              # Wait for MySQL to initialize
              sleep 30

              # Run backend container with memory limits
              docker run -d --name task-back \
                --network app-network \
                -e SPRING_PROFILES_ACTIVE=dev \
                -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/task_db \
                -e JAVA_OPTS="-Xmx384m -Xms128m" \
                -p 8080:8080 \
                --memory=384m \
                mathfrancisco/todolist-backend:latest

              # Run frontend container with memory limits
              docker run -d --name task-front \
                --network app-network \
                -p 80:80 \
                --memory=256m \
                mathfrancisco/todolist-frontend:latest

              # Configurar o Docker para iniciar na inicialização do sistema
              systemctl enable docker
              EOF
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
