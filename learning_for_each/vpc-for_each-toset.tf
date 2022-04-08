#######
# toset
########
variable "vpc-toset" {
  default = ["10.50.0.0/16",
             "10.60.0.0/16"]
}

resource "aws_vpc" "vpcs" {
  for_each = toset(var.vpc-toset)
  cidr_block = each.value
}