provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
    cidr_block  = "10.0.0.0/16"
    instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "subnet2"
  }
}

resource "aws_db_instance" "my_db1" {
  allocated_storage = 20
  identifier = "sampleinstance"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  name = "my_db1"
  username = "Myadmin"
  password = "MyDBAdmin"
  skip_final_snapshot = true
  apply_immediately = true
}

resource "aws_subnet" "priv-subnet1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}
