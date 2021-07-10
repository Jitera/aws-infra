output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "default_security_group_id" {
  description = "ID of the default security group"
  value       = module.vpc.default_security_group_id
}

output "public_subnets" {
  description = "A list of public subnets inside the VPC"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "A list of database subnets inside the VPC"
  value       = module.vpc.database_subnets
}
output "elasticache_subnet_group_name" {
  description = "Name of elasticache subnets inside the VPC"
  value       = module.vpc.elasticache_subnet_group_name
}
