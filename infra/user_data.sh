#!/bin/bash

# Switch to root user
sudo su

# Update the system and install Docker
yum update -y
yum install -y docker

# Start Docker service
service docker start

# Add ec2-user to the docker group
usermod -a -G docker ec2-user

# Create a docker network
docker network create app-network

# Run MySQL container
docker run -d --name mysql \
  --network app-network \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=task_db \
  -p 3306:3306 \
  mysql:8.0

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
sleep 30

# Run Backend container
docker run -d --name task-back \
  --network app-network \
  -e SPRING_PROFILES_ACTIVE=dev \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/task_db \
  -p 8080:8080 \
  mathfrancisco/todolist-backend:latest

# Run Frontend container
docker run -d --name task-front \
  --network app-network \
  -p 80:80 \
  mathfrancisco/todolist-frontend:latest

# Print container status
echo "Container status:"
docker ps -a
