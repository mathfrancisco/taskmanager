#!/bin/bash
# Cria diretório para o Docker Compose
mkdir -p /var/app/current

# Cria o arquivo docker-compose.yml
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
      - '3306:3306'
    volumes:
      - ./mysql-data:/var/lib/mysql
  backend:
    container_name: task-back
    image: mathfrancisco/todolist-backend:latest
    environment:
      SPRING_PROFILES_ACTIVE: dev
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/task_db
    ports:
      - '8080:8080'
    depends_on:
      - mysql
  frontend:
    container_name: task-front
    image: mathfrancisco/todolist-frontend:latest
    ports:
      - '80:80'
    depends_on:
      - backend
networks:
  default:
    driver: bridge
EOT

# Inicia os containers usando Docker Compose
docker-compose -f /var/app/current/docker-compose.yml up -d
