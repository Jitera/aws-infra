
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "iam_arn" {
  description = "ARN of codedeploy iam"
  default     = ""
}

variable "ecs_web_service_name" {
  description = "Name of ecs service"
  default     = ""
}

variable "alb_listner_arns" {
  description = "ARNs of alb"
  default     = []
}

variable "alb_target_blue_name" {
  description = "Name of target group for blue"
  default     = ""
}

variable "alb_target_green_name" {
  description = "NAME of target group for green"
  default     = ""
}