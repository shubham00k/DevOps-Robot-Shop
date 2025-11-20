resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name                                                                               =  "${var.cluster_name}-vpc"
           "kubernetes.io/cluster/${var.cluster_name}"                                 = "shared"
                                                        
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.name.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name                                                                               = "${var.cluster_name}-private-subnet-${count.index + 1}"
           "kubernetes.io/cluster/${var.cluster_name}"                                 = "shared"
          "kubernetes.io/role/elb"                                                     = "1"
  }

}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id            = aws_vpc.name.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
map_public_ip_on_launch = "true"
  tags = {
    Name                                                                               = "${var.cluster_name}-public-subnet-${count.index + 1}"
           "kubernetes.io/cluster/${var.cluster_name}"                                 = "shared"
          "kubernetes.io/role/elb"                                                     = "1"
  }
  
} 

resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "${var.cluster_name}-igw"
                                         
  }
}

resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)

  domain = "vpc"
  
  tags = {
    Name = "${var.cluster_name}-nat-eip-${count.index + 1}"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  } 
  tags = {
    Name = "${var.cluster_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  
} 

resource "aws_nat_gateway" "private" {
  count = length(var.private_subnet_cidrs)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat-gateway-${count.index + 1}"
  }
  
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.name.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private[count.index].id
  }

  tags = {
    Name = "${var.cluster_name}-private-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
