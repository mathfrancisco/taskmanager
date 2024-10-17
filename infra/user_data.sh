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
                --memory=512m \
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