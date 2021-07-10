
output "codepipeline_web_arn" {
  description = "ARN of codepipeline"
  value       = aws_codepipeline.web.arn
}