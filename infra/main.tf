# Provider configuration
provider "aws" {
  region = "sa-east-1"
}

# IAM Role for EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the EC2 role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.eb_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "eb_multicontainer_docker" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  role       = aws_iam_role.eb_ec2_role.name
}

# Create the Instance Profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb-ec2-instance-profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "taskmanager-app"
  description = "TaskManager Application"
}

# Security Group
resource "aws_security_group" "securitygroup" {
  name        = "securitygroup"
  description = "Allow HTTP, custom app port, and outbound internet access"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Template
resource "aws_launch_template" "eb_launch_template" {
  name = "eb-launch-template"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install -y docker
    service docker start
    usermod -a -G docker ec2-user
    docker network create app-network
    docker run -d --name mysql \
      --network app-network \
      -e MYSQL_ROOT_PASSWORD=root \
      -e MYSQL_DATABASE=task_db \
      -p 3306:3306 \
      mysql:8.0
    echo "Waiting for MySQL to be ready..."
    sleep 30
    docker run -d --name task-back \
      --network app-network \
      -e SPRING_PROFILES_ACTIVE=dev \
      -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/task_db \
      -p 8080:8080 \
      mathfrancisco/todolist-backend:latest
    docker run -d --name task-front \
      --network app-network \
      -p 80:80 \
      mathfrancisco/todolist-frontend:latest
    echo "Container status:"
    docker ps -a
  EOF
  )
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "taskmanager-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.8 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "vpc-07632126143031ff9"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "subnet-053d508166aa85895,subnet-05c26f9ac7c48daf6"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COMPOSE_PROJECT_NAME"
    value     = "taskmanager"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:proxy"
    name      = "ProxyServer"
    value     = "nginx"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.service_role.name
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro,t3.small"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.securitygroup.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplateId"
    value     = aws_launch_template.eb_launch_template.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplateVersion"
    value     = aws_launch_template.eb_launch_template.latest_version
  }
}

# IAM Role for Elastic Beanstalk service
resource "aws_iam_role" "service_role" {
  name = "eb-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = { Service = "elasticbeanstalk.amazonaws.com" }
      }
    ]
  })
}

# Attach policies to the service role
resource "aws_iam_role_policy_attachment" "eb_enhanced_health" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
  role       = aws_iam_role.service_role.name
}

resource "aws_iam_role_policy_attachment" "eb_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
  role       = aws_iam_role.service_role.name
}

# Output the Elastic Beanstalk URL
output "eb_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}