resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "main-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet" }
}

# App subnet (private)
resource "aws_subnet" "app" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_subnet_cidr
  tags = { Name = "app-subnet" }
}

# Monitoring subnet (private)
resource "aws_subnet" "monitoring" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.monitoring_subnet_cidr
  tags = { Name = "monitoring-subnet" }
}

# Data subnet (private)
resource "aws_subnet" "data" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.data_subnet_cidr
  tags = { Name = "data-subnet" }
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "app-rt" }
}

resource "aws_route_table" "monitoring" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "monitoring-rt" }
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "data-rt" }
}

# Associations
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app_assoc" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "monitoring_assoc" {
  subnet_id      = aws_subnet.monitoring.id
  route_table_id = aws_route_table.monitoring.id
}

resource "aws_route_table_association" "data_assoc" {
  subnet_id      = aws_subnet.data.id
  route_table_id = aws_route_table.data.id
}

# S3 Gateway Endpoint (attached to all route tables so subnets can access S3 without NAT)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [
    aws_route_table.public.id,
    aws_route_table.app.id,
    aws_route_table.monitoring.id,
    aws_route_table.data.id,
  ]
  tags = { Name = "s3-endpoint" }
}
