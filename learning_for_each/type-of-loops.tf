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


resource "aws_instance" "ec2_example" {

   ami           = "ami-0c02fb55956c7d316"
   instance_type =  "t2.micro"
   count = 1

   tags = {
           Name = "Terraform EC2"
   }

}

#######
# Count
########
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
}

##########
# for_each
###########
variable "users" {
  description = "IAM Users"
  type = set(string)
  default = [ "asim", "qasim" ]
}

resource "aws_iam_user" "iam_users" {
  for_each = var.users
  name     = each.value
}

###########
# for loop
###########
output "print_the_names" {
 value= [ for names in var.users : names ]
}