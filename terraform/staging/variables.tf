
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "env" {
  description = "Environment that is used as placeholder"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  default     = []
}

variable "database_name" {
  description = "Name of database name"
  default     = ""
}

variable "lb_healthcheck_path" {
  description = "Path of loadbalancer's health check"
  default     = ""
}

variable "database_user" {
  description = "Name of database user"
  default     = ""
}

variable "database_password" {
  description = "Name of database password"
  default     = ""
}

variable "rails_master_key" {
  description = "Encrypted key as rails master key"
  default     = ""
}

variable "github_account" {
  description = "Github account name of access token"
  default     = ""
}

variable "github_repository" {
  description = "Github repository to get source"
  default     = ""
}

variable "github_branch" {
  description = "Git branch to get source"
  default     = ""
}

variable "github_token" {
  description = "Github personal access token"
  default     = ""
}

variable "web_container_name" {
  description = "Name of the web container image"
  default     = ""
}

variable "secret_key_base" {
  description = "Secret token for rails project"
  default     = ""
}

variable "ssl_cert_arn" {
  description = "ARN of ssl certs"
  default     = ""
}
variable "docker_username" {
  description = "ARN of ssl certs"
  default     = ""
}

variable "docker_password" {
  description = "Docker Passwrd"
  default     = ""
}

# variable "snapshot_identifier" {
#   description = ""
#   default     = ""
# }

variable "elasticache_subnets" {
  description = "Elasticache Subnets"
}

variable "redis_name" {
  description = "Redis Name"
}

variable "database_host_title" {
  description = "Refernce for ENV since dynamic script"
}

variable "database_password_title" {
  description = "Refernce for ENV since dynamic script"
}
