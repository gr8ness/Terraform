resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_P21.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "P21_SG"
  }
}

resource "aws_vpc" "vpc_P21" {
  cidr_block              = "10.0.0.0/16"

  tags = {
    Name = "Ps21_VPC"
  }
}