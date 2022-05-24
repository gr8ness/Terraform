# terraform {
#   required_providers {
#     docker = {
#       source = "kreuzwerker/docker"
#     }

#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.15.1"
#     }
#   }
# }

# # download centos image

# provider "docker" {}

# # start the container

# resource "docker_container" "centos_container" {
#   name  = "centos"
#   image = docker_image.centos_image.latest
#   ports {
#     internal = 1880
#     external = 1880
#   }
# }


#####
# ECS cluster and fargate
#####

resource "aws_ecs_cluster" "centos_cluster" {
  name = "ecs_centos_cluster"
}

module "ecs-fargate_example_core" {
  source  = "umotif-public/ecs-fargate/aws"
  version = "~>6.5.0"

  # sg_name_prefix     = "my-security-group-name" # uncomment if you want to name security group with specific name
  name_prefix        = "ecs-fargate_example_core"
  vpc_id             = aws_vpc.docker_centos_vpc.id
  private_subnet_ids = ["subnet-0b1935076b50bdfd2"]
  cluster_id         = aws_ecs_cluster.centos_cluster.id

  wait_for_steady_state = true

  platform_version = "1.4.0" # defaults to LATEST

  task_container_image   = "centos:latest"
  task_definition_cpu    = 256
  task_definition_memory = 512

  task_container_port             = 80
  task_container_assign_public_ip = true

   load_balanced = false

  target_groups = [
    {
      target_group_name = "docker_tg"
      container_port    = 80
    }
  ]

  health_check = {
    port = "traffic-port"
    path = "/"
  }

  task_stop_timeout = 90

  # depends_on = [
  #   module.alb
  # ]
  tags = {
    "Environment" = "dev"
    "Project" = "LUIT20"
  }
}

#####
# VPC
#####

resource "aws_vpc" "docker_centos_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true #Determines whether the VPC supports assigning public DNS hostnames to instances with public IP addresses.

  tags = {
    Name = "docker_centos_vpc"
  }
}

# data "aws_vpc" "docker_vpc" {
  
# }

#####
# Public subnet
#####

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.docker_centos_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1_"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.docker_centos_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet2_"
  }
}


#####
# Private subnet
#####
resource "aws_subnet" "private_subnets" {
  vpc_id             = aws_vpc.docker_centos_vpc.id
  cidr_block         = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
      Name = "priv_subnet1_"
    }
}


#####
# Public and Private IGW
#####
resource "aws_internet_gateway" "igw_docker_centos_public" {
  vpc_id = aws_vpc.docker_centos_vpc.id

  tags = {
    Name = "igw_docker_centos_public"
  }
}

resource "aws_internet_gateway" "igw_docker_centos_priv" {
  vpc_id = aws_vpc.docker_centos_vpc.id

  tags = {
    Name = "igw_docker_centos_priv"
  }
}


#####
# Security group
#####

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.docker_centos_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }
}

#####
# Public and Private routing table
#####

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.docker_centos_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.igw_docker_centos_public.id
  }

  tags = {
    Name = "public_route_table_docker"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.docker_centos_vpc.id

  tags = {
    Name = "praivate_route_table_docker"
  }
}
