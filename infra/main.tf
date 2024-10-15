provider "aws" {
  region = "sa-east-1"
}

resource "aws_elastic_beanstalk_application" "app" {
  name        = "taskmanager-app"
  description = "TaskManager Application"
}

resource "aws_security_group" "securitygroup" {
  name        = "securitygroup"
  description = "Permitir acesso HTTP e acesso a Internet"
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
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "taskmanager-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.8 running Docker"

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

  # Use o script de usuário para configurar o Docker Compose
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "USER_DATA_SCRIPT"
    value     = base64encode(file("user_data.sh"))
  }
}

resource "aws_iam_instance_profile" "eb_profile" {
  name = "eb-ec2-instance-profile"
  role = aws_iam_role.eb_role.name
}

resource "aws_iam_role" "eb_role" {
  name               = "eb-ec2-role"
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

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.eb_role.id
}

output "eb_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}
