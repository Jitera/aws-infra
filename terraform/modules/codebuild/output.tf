
output "web_name" {
  description = "Name of cloud watch group for ecs"
  value       = aws_codebuild_project.web.name
}