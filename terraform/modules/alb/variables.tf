variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "vpc_id" {
  description = "ID of vpc"
  default     = ""
}

variable "subnets" {
  description = "A list of subnets to set asg"
  default     = []
}

variable "security_groups" {
  description = "A list of security group ids for asg"
  default     = []
}

variable "access_log_bucket_id" {
  description = "ID of S3 bucket to store access log"
  default     = ""
}

variable "lb_healthcheck_path" {
  description = "Path of loadbalancer's health check"
  default     = ""
}

variable "ssl_cert_arn" {
  description = "ARN of ssl certs"
  default     = ""
}