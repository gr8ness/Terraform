terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
      
    }
  }
}

# # Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
 }
