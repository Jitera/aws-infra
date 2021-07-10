output "cluster_address" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}
output "port" {
  value = aws_elasticache_cluster.redis.cache_nodes.0.port
}
