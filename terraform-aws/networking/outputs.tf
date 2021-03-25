# -- networking/outputs.tf --

output "vpc_id" {
  value = aws_vpc.peter_vpc.id
}