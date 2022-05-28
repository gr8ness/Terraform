module "ec2" {
  source = "./modules/ec2"
  
  instance_ami = var.instance_ami
  instance_type = var.instance_type
  }

