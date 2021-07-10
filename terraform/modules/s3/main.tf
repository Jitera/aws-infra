
module "access_log_s3_bucket" {
  source                         = "terraform-aws-modules/s3-bucket/aws"
  version                        = "v1.17.0"
  bucket                         = var.access_log_name
  acl                            = "log-delivery-write"
  force_destroy                  = true
  attach_elb_log_delivery_policy = true
  tags = {
    Terraform = "true"
  }
}

module "pipeline_artifact_s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "v1.17.0"
  bucket        = var.pipeline_artifact_name
  acl           = "private"
  force_destroy = true
  tags = {
    Terraform = "true"
  }
}