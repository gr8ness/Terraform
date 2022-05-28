variable "instance_ami" {
    description = "ami ec2 instance"
    default = "ami-0022f774911c1d690"
    type = string
}

variable "instance_type" {
    description = "instance size"
    default = "t2.micro"
    type = string
}

variable "region" {
    description = "aws region"
    default = "us-east-1"
    
}