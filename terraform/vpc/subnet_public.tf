# Public subnets settings for ALB
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.car_rental.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "car-rental-public-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.car_rental.id

  tags = {
    Name = "car-rental-igw"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.car_rental.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "car-rental-public-subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# NAT Gateways for private subnets
resource "aws_eip" "nat_gw" {
  count      = length(var.private_subnets)
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet-gateway]
}


resource "aws_nat_gateway" "gw" {
  count         = length(var.private_subnets)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat_gw.*.id, count.index)

  tags = {
    Name = "car-rental-subnet-${count.index}"
  }
}
