# vpc and gateway
resource "aws_vpc" "mc-vpc" {
  cidr_block              = var.vpc_cidr
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
  tags                    = {
    Name                  = "mc-vpc"
  }
}

# internet gateway 
resource "aws_internet_gateway" "mc-gw" {
  vpc_id                  = aws_vpc.mc-vpc.id
  tags                    = {
    Name                  = "mc-gw"
  }
}

# public route table
resource "aws_route_table" "mc-pubrt" {
  vpc_id                  = aws_vpc.mc-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.mc-gw.id
  }
  tags                    = {
    Name                  = "mc-pubrt"
  }
}

# public subnet
resource "aws_subnet" "mc-pubnet" {
  vpc_id                  = aws_vpc.mc-vpc.id
  availability_zone       = data.aws_availability_zones.mc-azs.names[var.aws_az]
  cidr_block              = var.pubnet_cidr
  tags                    = {
    Name                  = "mc-pubnet"
  }
  depends_on              = [aws_internet_gateway.mc-gw]
}

# public route table associations
resource "aws_route_table_association" "rt-assoc-pubnet" {
  subnet_id               = aws_subnet.mc-pubnet.id
  route_table_id          = aws_route_table.mc-pubrt.id
}
