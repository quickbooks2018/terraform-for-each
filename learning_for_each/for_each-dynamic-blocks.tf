terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = "~> 1.0"
}


#####
# Vpc
#####
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name            = "vpc"

  cidr            = "10.60.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.60.0.0/23", "10.60.2.0/23", "10.60.4.0/23"]
  public_subnets  = ["10.60.100.0/23", "10.60.102.0/24", "10.60.104.0/24"]


  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = true

  enable_dns_hostnames = true
  enable_dns_support   = true


}

variable "sg_ingress" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = {

    "80" = {
      port     = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    "443" = {
      port     = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }



  }

}



resource "aws_security_group" "allow" {
  name        = "Vpc-Allowed"
  description = "Allow Inbound Traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {

  for_each    = var.sg_ingress

  content {
    description = "Allow with in VPC"
    from_port   = ingress.value.port
    to_port     = ingress.value.port
    protocol    = ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
  }

}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allowed Ports With in VPC"
  }
}