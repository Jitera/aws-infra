
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group"
  default     = ""
}

variable "iam_arn" {
  description = "ANR of codebuild"
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

variable "vpc_id" {
  description = "Id of the VPC"
  default     = []
}

variable "env" {
  description = "Environment that is used as placeholder"
  default     = ""
}