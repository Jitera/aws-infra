
output "db_endpoint" {
  description = "ID of the database"
  value       = module.db.this_db_instance_endpoint
}