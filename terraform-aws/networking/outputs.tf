# -- networking/outputs.tf --

output "vpc_id" {
  value = aws_vpc.peter_vpc.id
}

output "aws_zones" {
  value = data.aws_availability_zones.available
}


output "db_subnet_group_name" {
  value = aws_db_subnet_group.peter_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.peter_sg["rds"].id]
}

output "public_sg" {
  value = [aws_security_group.peter_sg["public"].id]
}


output "public_subnets" {
  value = aws_subnet.peter_public_subnet.*.id
}