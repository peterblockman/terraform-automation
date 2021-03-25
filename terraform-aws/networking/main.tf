# -- networking/main.tf --

resource "random_integer" "random" {
  min = 1
  max = 100
}


resource "aws_vpc" "peter_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "peter_vpc-${random_integer.random.id}"
  }

}


resource "aws_subnet" "peter_public_subnet" {
  count = length(var.public_cidrs)
  vpc_id = aws_vpc.peter_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = ["us-west-1b", "us-west-1c"][count.index]

  tags = {
    Name = "peter_public_vpc-${count.index + 1}"
  }
}

resource "aws_subnet" "peter_private_subnet" {
  count = length(var.private_cidrs)
  vpc_id = aws_vpc.peter_vpc.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = ["us-west-1b", "us-west-1c"][count.index]

  tags = {
    Name = "peter_private_vpc-${count.index + 1}"
  }
}