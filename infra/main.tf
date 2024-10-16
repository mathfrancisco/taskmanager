# Provider configuration
provider "aws" {
  region = "sa-east-1"
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
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "taskmanager-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Multi-container Docker"


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_profile.name
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

  # Use the user data script to set up Docker Compose
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "UserData"
    value     = base64encode(file("user_data.sh"))
  }

  # Enable multi-container Docker
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.service_role.name
  }
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "eb_profile" {
  name = "eb-ec2-instance-profile"
  role = aws_iam_role.eb_role.name
}

# IAM Role for EC2 instances
resource "aws_iam_role" "eb_role" {
  name = "eb-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

# Attach policies to the EC2 role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.eb_role.id
}

resource "aws_iam_role_policy_attachment" "eb_multicontainer_docker" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  role       = aws_iam_role.eb_role.id
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
  role       = aws_iam_role.service_role.id
}

resource "aws_iam_role_policy_attachment" "eb_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
  role       = aws_iam_role.service_role.id
}

# Output the Elastic Beanstalk URL
output "eb_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}
