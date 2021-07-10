
output "log_group_codebuild_arn" {
  description = "ARN of cloud watch group for codebuild"
  value       = aws_cloudwatch_log_group.codebuild.arn
}

output "log_group_codebuild_name" {
  description = "Name of cloud watch group for codebuild"
  value       = aws_cloudwatch_log_group.codebuild.name
}

output "log_group_ecs_name" {
  description = "Name of cloud watch group for ecs"
  value       = aws_cloudwatch_log_group.ecs.name
}