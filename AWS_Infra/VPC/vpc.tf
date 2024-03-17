resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.Name}-vpc"
  }
}

resource "aws_subnet" "public-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_sn_cidr

  tags = {
    Name = "${var.Name}-Public-Subnet"
  }
}

resource "aws_subnet" "private-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.Name}-Private-Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.Name}-IGW-01"
  }
}

resource "aws_eip" "eip_nat" {
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public-sn.id

  tags = {
    Name = "${var.Name}-NAT-GW"
  }

}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.Name}-private-rt"
  }

  depends_on = [ aws_nat_gateway.nat_gateway ]
}

resource "aws_route_table_association" "private-sn-association" {
  subnet_id      = aws_subnet.private-sn.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.Name}-public-rt"
  }
}

resource "aws_route_table_association" "public-sn-association" {
  subnet_id      = aws_subnet.public-sn.id
  route_table_id = aws_route_table.public-rt.id
}


output "public_sn" {
  value = aws_subnet.public-sn.id
}


output "vpc_id" {
  value = aws_vpc.main.id
}