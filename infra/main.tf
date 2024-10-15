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
  solution_stack_name = "64bit Amazon Linux 2 v3.5.7 running Multi-container Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.nano"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.securitygroup.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "chaveum"  # Coloque o nome do seu par de chaves EC2
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  # Configurações da aplicação (variáveis de ambiente)
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MYSQL_ROOT_PASSWORD"
    value     = "root"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MYSQL_DATABASE"
    value     = "task_db"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "dev"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_DATASOURCE_URL"
    value     = "jdbc:mysql://mysql:3306/task_db"
  }
}

resource "aws_iam_instance_profile" "eb_profile" {
  name = "eb-ec2-instance-profile"
  role = aws_iam_role.eb_role.name
}

resource "aws_iam_role" "eb_role" {
  name = "eb-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
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
