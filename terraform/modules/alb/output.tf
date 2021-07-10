
output "lb_listener_arns" {
  description = "ARN of the application load balancer listner"
  value       = [aws_lb_listener.web_https.arn]
}

output "target_group_blue_arn" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.blue.arn
  depends_on = [ // Needs to specify dependencies. If not terraform apply fails sometimes.
    aws_lb_listener.web_http,
    aws_lb_listener.web_https
  ]
}

output "target_group_blue_name" {
  description = "Name of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.blue.name
}

output "target_group_green_name" {
  description = "Name of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.green.name
}