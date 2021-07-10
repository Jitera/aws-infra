

output "web_name" {
  description = "Name of codedeploy"
  value       = aws_codedeploy_app.web.name
}