module "ec2" {
  source = "./modules/ec2"

  }

module "sg" {
  source = "./modules/vpc"
  
  cidr_block = var.cidr_block
}

# variable "location" {
#   description = "aws region"
#   default = "us-east-1"
# }
