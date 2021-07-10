
output "access_log_bucket_id" {
  description = "The ID of the bucket for access log"
  value       = module.access_log_s3_bucket.this_s3_bucket_id
}

output "pipeline_artifact_bucket_id" {
  description = "The ID of the bucket for pipeline artifact"
  value       = module.pipeline_artifact_s3_bucket.this_s3_bucket_id
}

output "pipeline_artifact_bucket_arn" {
  description = "ARN of the bucket for pipeline artifact"
  value       = module.pipeline_artifact_s3_bucket.this_s3_bucket_arn
}