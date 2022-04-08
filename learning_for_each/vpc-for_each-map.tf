################
# map of objects
################
variable "vpcs" {
  type = map(object({
    cidr = string
    tags = map(string)
    tenancy = string
  }))
  default = {
    "vpc1" = {
      cidr = "10.10.0.0/16"
      tags = {
        "Name" = "vpc-1"
      }
      tenancy = "default"
    }

    "vpc2" = {
      cidr = "10.90.0.0/16"
      tags = {
        "Name" = "vpc-2"
      }
      tenancy = "default"
    }


  }


}

resource "aws_vpc" "vpc" {
  for_each = var.vpcs
  cidr_block = each.value["cidr"]
  instance_tenancy = each.value["tenancy"]
  tags = each.value["tags"]
}

