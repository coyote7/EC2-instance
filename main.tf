terraform {
  required_providers {
    aws = {
      version = ">=4.16"
      source  = "hashicorp/aws"
    }
  }
  required_version = "~>1.5.4"
}
provider "aws" {
  region  = "us-east-1"
  profile = "superuser"
}
resource "aws_instance" "server_ec2" {
  ami                         = "ami-06db4d78cb1d3bbf9"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.server-sg.id]
  tags={
    Name="Server"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                systemctl start apache2
                systemctl enable apache2
                EOF

  user_data_replace_on_change = true
}
resource "aws_security_group" "server-sg" {
  name = "server-sg"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = var.protocol
    cidr_blocks = var.all_ips
  }
  egress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = var.protocol
    cidr_blocks = var.all_ips
  }
}
