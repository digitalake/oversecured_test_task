resource "aws_vpc" "project_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_prefix}-project-vpc"
  }
}

resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

resource "aws_nat_gateway" "vpc_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet1.id
}

resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "${var.project_prefix}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_internet_gateway.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc_nat_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet1_routing_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_routing_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az[0]

  tags = {
    Name = "${var.project_prefix}-private-subnet"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_prefix}-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = var.az[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_prefix}-public-subnet2"
  }
}