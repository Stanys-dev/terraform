terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
  cloud {
    organization = "Stanys-dev"

    workspaces {
      name = "Learning-day"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-065deacbcaac64cf2"
  instance_type = "t2.nano"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_security_group" "web_server_sg" {
  name = "web_server_sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web_server.public_dns}:8080"
}
