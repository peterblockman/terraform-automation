# -- networking/main.tf --


data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "peter_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "peter_vpc-${random_integer.random.id}"
  }
  lifecycle {
    # to make sure that other resource will link to this properly
    create_before_destroy = true
  }

}


resource "aws_subnet" "peter_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.peter_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "peter_public_vpc-${count.index + 1}"
  }
}

#connect public roundtable to public subnet
resource "aws_route_table_association" "peter_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.peter_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.peter_public_rt.id
}

resource "aws_subnet" "peter_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.peter_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "peter_private_vpc-${count.index + 1}"
  }

}

# the gateway to the internet
resource "aws_internet_gateway" "peter_internet_gateway" {
  vpc_id = aws_vpc.peter_vpc.id

  tags = {
    Name = "peter_igw"
  }
}

# the route table
resource "aws_route_table" "peter_public_rt" {
  vpc_id = aws_vpc.peter_vpc.id
  tags = {
    Name = "peter_public_rt"
  }
}

# the default route is where all traffic goes that isn't specifically destined for something.
# if you haven't set up any forwarding rules to forward to another VPC 
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.peter_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.peter_internet_gateway.id
}


# the route table that subnets will use if they haven't been explicitly associated with one
resource "aws_default_route_table" "peter_private_rt" {
  # use default_route_table_id frpm aws_vpc
  default_route_table_id = aws_vpc.peter_vpc.default_route_table_id
  tags = {
    Name = "peter_private_rt"
  }
}


resource "aws_security_group" "peter_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.peter_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      # Same name with "ingress"
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_db_subnet_group" "peter_rds_subnetgroup" {
  count = var.db_subnet_group == true ? 1: 0
  name       = "peter_rds_subnetgroup"
  subnet_ids = aws_subnet.peter_private_subnet.*.id

  tags = {
    Name = "peter_rds_sng"
  }
}
