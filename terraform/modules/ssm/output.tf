
output "database_host_arn" {
  description = "ARN of database host"
  value       = aws_ssm_parameter.database_host.arn
}

output "database_password_arn" {
  description = "ARN of database password"
  value       = aws_ssm_parameter.database_password.arn
}

output "rails_master_key_arn" {
  description = "ARN of rails master key"
  value       = aws_ssm_parameter.rails_master_key.arn
}

output "redis_address_arn" {
  description = "ARN of the redis address"
  value       = aws_ssm_parameter.redis_address.arn
}

output "git_token_arn" {
  description = "ARN of the git token"
  value       = aws_ssm_parameter.git_token.arn
}

output "database_host_title_arn" {
  description = "Refernce for ENV since dynamic script"
    value       = aws_ssm_parameter.database_host_title.arn

}

output "database_password_title_arn" {
  description = "Refernce for ENV since dynamic script"
  value       = aws_ssm_parameter.database_password_title.arn
}

