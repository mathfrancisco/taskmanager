#!/bin/bash

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create directory for Docker Compose
mkdir -p /var/app/current

# Create the docker-compose.yml file
cat <<EOT > /var/app/current/docker-compose.yml
version: '3'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: task_db
    ports:
      - "3306:3306"
    volumes:
      - ./Task/data:/var/lib/mysql
    networks:
      - app-network

  backend:
    container_name: task-back
    image: mathfrancisco/todolist-backend:latest
    environment:
      SPRING_PROFILES_ACTIVE: dev
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/task_db
    ports:
      - "8080:8080"
    depends_on:
      - mysql
    networks:
      - app-network

  frontend:
    container_name: task-front
    image: mathfrancisco/todolist-frontend:latest
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
EOT

# Start the containers using Docker Compose
cd /var/app/current
docker-compose up -d
