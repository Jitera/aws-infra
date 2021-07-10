
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "env" {
  description = "Environment that is used as placeholder"
  default     = ""
}

variable "iam_arn" {
  description = "ARN of codepipeline"
  default     = ""
}

variable "s3_id" {
  description = "S3 id for artifact store"
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

variable "codedeploy_name" {
  description = "Name of codedeploy"
  default     = ""
}

variable "codebuild_name" {
  description = "Name of codedeploy"
  default     = ""
}

variable "web_container_name" {
  description = "Name of web container name"
  default     = ""
}