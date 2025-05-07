
# Fetch AZs in the current region
# data "aws_availability_zones" "available" {
# }

resource "aws_vpc" "ecs" {
  cidr_block = "172.17.0.0/16"
  tags = {
    Name = "ecs-terraform-vpc"
  }
}


# Public subnets settings for ALB
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.ecs.id
  cidr_block              = cidrsubnet(aws_vpc.ecs.cidr_block, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.ecs.id

  tags = {
    Name = "igw-public-subnet"
  }
}


resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "route-table-public-subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.prod-route-table.id
}


# Private subnet settings for ECS
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.ecs.id
  cidr_block        = cidrsubnet(aws_vpc.ecs.cidr_block, 8, 2 + count.index) # "172.17.3.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_eip" "nat_gw" {
  count      = 2
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet-gateway]
}


resource "aws_nat_gateway" "gw" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat_gw.*.id, count.index)

  tags = {
    Name = "nat-gateway-subnet-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.ecs.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }

  tags = {
    Name = "route-table-private-subnet-${count.index}"
  }

}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
