locals {
  // underscore is prefereble according to official terraform bestpractice, but redis only accepts hyphen based name.
  identifier = replace(var.name, "_", "-")
}
resource "aws_elasticache_parameter_group" "this" {
  name   = local.identifier
  family = "redis6.x"

  parameter {
    name  = "maxmemory-policy"
    value = "noeviction"
  }
}
resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = local.identifier
  replication_group_description = "Redis for ${local.identifier} application"
  node_type                     = "cache.t3.micro"
  number_cache_clusters         = var.env == "production" ? 2 : 1
  automatic_failover_enabled    = var.env == "production" ? true : false
  auto_minor_version_upgrade    = true
  engine                        = "redis"
  engine_version                = "6.x"
  parameter_group_name          = aws_elasticache_parameter_group.this.name
  maintenance_window            = "Sun:12:00-Sun:13:00"
  port                          = 6379
  availability_zones            = slice(var.azs, 0, var.env == "production" ? 2 : 1)
  subnet_group_name             = var.elasticache_subnets
  security_group_ids            = var.security_groups
  tags = {
    Terraform   = "true"
    Service     = var.service
    DatadogFlag = var.name
  }
  lifecycle {
    ignore_changes = [
      engine_version,
      tags,
      id,
      number_cache_clusters
    ]
  }
}
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  replication_group_id = aws_elasticache_replication_group.this.id
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
