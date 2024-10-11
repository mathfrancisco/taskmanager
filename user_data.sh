#!/bin/bash

# Update the system and install Docker (if not already installed by EB)
yum update -y
yum install -y docker

# Start Docker service
service docker start

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Set up environment variables
echo "export MYSQL_ROOT_PASSWORD=root" >> /etc/environment
echo "export MYSQL_DATABASE=task_db" >> /etc/environment

# Reload environment variables
source /etc/environment

# Enable Docker to start on boot
systemctl enable docker
