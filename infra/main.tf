provider "aws" {
  region = "sa-east-1"
}

resource "aws_security_group" "securitygroup" {
  name        = "ec2-securitygroup"
  description = "Allow HTTP, custom app ports, and SSH access"

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

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_key_pair" "keypair" {
  key_name   = "terraform-keypair"
  public_key = file("~/.ssh/id_ed25519.pub")
}


resource "aws_instance" "ec2" {
  ami           = "ami-0989c1b438266c944"  # Verifique se esse AMI está disponível em sa-east-1
  instance_type = "t3.micro"
  key_name      = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.securitygroup.id]
  user_data              = file("user_data.sh")
  # Habilitar monitoramento detalhado (opcional, mas útil para acompanhar o uso de recursos)
  monitoring = true

}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
