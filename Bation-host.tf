provider "aws" {
  region = "ap-northeast-1"
}


resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}


resource "aws_subnet" "public-sub"{
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "public-subnet"
  }
}


resource "aws_subnet" "private-sub"{
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "main-igw"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public-sub.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-sub.id

  tags = {
    Name = "nat-gateway"
  }
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private-sub.id
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_instance" "terraform" {
  ami           = "ami-03852a41f1e05c8e4" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-sub.id
  key_name = "tokyoroyals"

  user_data = <<-EOF
    #!/bin/bash
    echo "public-key" > /home/ec2-user/key.pem
       EOF
  tags = {
    Name = "terraform"
  }
}

resource "aws_instance" "Bation-host" {
  ami           = "ami-03852a41f1e05c8e4" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private-sub.id
  

  
  tags = {
    Name = "Bation-host"
  }
}
