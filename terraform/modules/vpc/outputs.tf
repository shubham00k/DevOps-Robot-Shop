output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_vpc.name.id
  
}

output "private_subnet_ids" {
    description = "IDs of the private subnets"
    value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
    description = "IDs of the public subnets"
    value       = aws_subnet.public[*].id
}