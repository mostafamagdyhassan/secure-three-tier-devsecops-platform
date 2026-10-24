output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private application subnets"
  value       = aws_subnet.private[*].id
}

output "database_subnet_group_name" {
  description = "Name of the private database subnet group"
  value       = aws_db_subnet_group.main.name
}

output "aws_region" {
  description = "AWS region used by this deployment"
  value       = var.aws_region
}
