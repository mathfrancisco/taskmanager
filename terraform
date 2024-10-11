provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "eb_bucket" {
  bucket = "eb-app-bucket-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_ownership_controls" "eb_bucket_ownership" {
  bucket = aws_s3_bucket.eb_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "eb_bucket_public_access" {
  bucket = aws_s3_bucket.eb_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "eb_bucket_versioning" {
  bucket = aws_s3_bucket.eb_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "user_data_script" {
  bucket = aws_s3_bucket.eb_bucket.id
  key    = "user_data.sh"
  source = "user_data.sh"
  etag   = filemd5("user_data.sh")
}

resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "todo-list-app"
  description = "Todo List Application"
}

resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "todo-list-env"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.7 running Multi-container Docker"

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
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
  namespace = "aws:elasticbeanstalk:application:environment"
  name      = "USER_DATA_SCRIPT"
  value     = "s3://${aws_s3_bucket.eb_bucket.id}/${aws_s3_object.user_data_script.key}"
}

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.main.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
}

resource "aws_iam_role" "eb_service_role" {
  name = "eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb-instance-profile"
  role = aws_iam_role.eb_service_role.name
}

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.eb_service_role.id
}

resource "aws_iam_role_policy_attachment" "eb_worker_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
  role       = aws_iam_role.eb_service_role.id
}

resource "aws_iam_role_policy_attachment" "eb_multicontainer_docker" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  role       = aws_iam_role.eb_service_role.id
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eb_service_role.id
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "todo-list-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "todo-list-igw"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "todo-list-subnet"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "todo-list-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

output "eb_url" {
  value = aws_elastic_beanstalk_environment.eb_env.endpoint_url
}
