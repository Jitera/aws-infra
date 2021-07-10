
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group"
  default     = ""
}

variable "image_url" {
  description = "URL of ecr image url"
  default     = ""
}

variable "lb_blue_arn" {
  description = "ARN of application loadbalancer"
  default     = ""
}

variable "subnets" {
  description = "Ids of the subnets"
  default     = []
}

variable "security_groups" {
  description = "Ids of the security groups"
  default     = []
}

variable "iam_arn" {
  description = "ARN of ECS Task"
  default     = ""
}

variable "web_container_name" {
  description = "Name of the docker image"
  default     = ""
}

variable "database_password_arn" {
  description = "ARN of database password"
  default     = ""
}

variable "database_host_arn" {
  description = "ARN of the database host"
  default     = ""
}

variable "rails_master_key_arn" {
  description = "ARN of rails master key"
  default     = ""
}

variable "env" {
  description = "ENV rails"
  default     = ""
}

variable "redis_address_arn" {
  description = "ARN of redis"
  default     = ""
}

variable "git_token_arn" {
  description = "Github Token ARN"
}

variable "database_host_title_arn" {
  description = "Refernce for ENV since dynamic script"
}

variable "database_password_title_arn" {
  description = "Refernce for ENV since dynamic script"
}
