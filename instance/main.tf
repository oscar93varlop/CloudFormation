terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}
provider "aws" {
  region="us-east-1"
}

resource "aws_security_group" "ssh_conection" {
  name   = var.sg_name
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

}
resource "aws_instance" "terraform_test" {
      #ami = "ami-0e391adda4e7c88b7"
      ami = var.ami_id
      instance_type = var.instance_type
      tags = var.tags
      security_groups = ["${aws_security_group.ssh_conection.name}"]
      provisioner "remote-exec" {
        connection {
          type = "ssh"
          user = "centos"
          private_key = "${file(C:\Users\PC\Downloads\IaCtest.ppk)}"
          host = self.public_ip
        }
        inline =["wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm","sudo rpm -U ./amazon-cloudwatch-agent.rpm","amazon-cloudwatch-agent-ctl -a start","amazon-cloudwatch-agent-ctl -a status","echo -e "Agente de CloudWatch ha sido instalado con exito""]
      }
    }
