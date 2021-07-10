
output "cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.this.id
}

output "web_service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.web.name
}