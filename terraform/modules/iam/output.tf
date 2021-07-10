
output "codepipeline_arn" {
  description = "ARN of codepipeline iam"
  value       = aws_iam_role.codepipeline.arn
}

output "codebuild_arn" {
  description = "ARN of codebuild iam"
  value       = aws_iam_role.codebuild.arn
}

output "codedeploy_arn" {
  description = "ARN of codedeploy iam"
  value       = aws_iam_role.codedeploy.arn
}

output "ecs_tasks_arn" {
  description = "ARN of ecs_tasks iam"
  value       = aws_iam_role.ecs_tasks.arn
}