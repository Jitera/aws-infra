locals {
  // underscore is prefereble according to official terraform bestpractice, but alb only accepts hyphen based name.
  identifier = replace(var.name, "_", "-")
}

module "db" {
  source                          = "terraform-aws-modules/rds/aws"
  # snapshot_identifier             = var.snapshot_identifier ? var.snapshot_identifier : null
  version                         = "v2.20.0"
  identifier                      = local.identifier
  engine                          = "mysql"
  engine_version                  = "8.0.21"
  instance_class                  = "db.t3.micro"
  allocated_storage               = 10
  name                            = var.database_name
  username                        = var.user
  password                        = var.password
  port                            = "3306"
  vpc_security_group_ids          = var.security_groups
  maintenance_window              = "Sun:12:00-Sun:12:30"
  backup_window                   = "11:00-11:30"
  monitoring_interval             = "60"
  monitoring_role_name            = "rds_monitoring_${var.name}"
  create_monitoring_role          = true
  backup_retention_period         = 14
  subnet_ids                      = var.subnets
  db_subnet_group_name            = var.name
  major_engine_version            = "8.0"
  final_snapshot_identifier       = "${local.identifier}-final-snapshot"
  deletion_protection             = false
  allow_major_version_upgrade     = false
  apply_immediately               = false
  publicly_accessible             = false
  delete_automated_backups        = true
  auto_minor_version_upgrade      = true
  multi_az                        = false // We can make it true if iCode gets in use heavily
  storage_encrypted               = true
  enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]
  family                          = "mysql8.0"
  parameters = [
    {
      name         = "general_log"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_output"
      value        = "FILE"
      apply_method = "pending-reboot"
    },
    {
      name         = "slow_query_log"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_queries_not_using_indexes"
      value        = "0"
      apply_method = "pending-reboot"
    },
    {
      name         = "long_query_time"
      value        = "0.1"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_client"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_connection"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_database"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_results"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_server"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    },
    {
      name         = "skip-character-set-client-handshake"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "time_zone"
      value        = "Asia/Tokyo"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_allowed_packet"
      value        = "4194304" #4MB
      apply_method = "pending-reboot"
    }
  ]
  tags = {
    Terraform = "true"
  }
}
