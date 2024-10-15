#!/bin/bash
# Atualiza o sistema e instala o Docker
sudo su
yum update -y
amazon-linux-extras install docker -y

# Inicia o serviço Docker e habilita no boot
service docker start
usermod -a -G docker ec2-user
systemctl enable docker

# Instala o Docker Compose
curl -L "<https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)>" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Cria diretório para o Docker Compose
mkdir -p /var/app/current

# Adiciona o Docker Compose File no caminho correto
cat <<EOT >> /var/app/current/docker-compose.yml
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
 app-network:
 driver: bridge
EOT

# Rodar o Docker Compose
cd /var/app/current
docker-compose up -d