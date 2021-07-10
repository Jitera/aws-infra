
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "database_password" {
  description = "Password of the database"
  default     = ""
}

variable "database_host" {
  description = "Name of the database host"
  default     = ""
}

variable "web_container_name" {
  description = "Name of the docker image"
  default     = ""
}

variable "rails_master_key" {
  description = "Name of the rails master key"
  default     = ""
}
variable "docker_username" {
  description = "Docker username"
}

variable "docker_password" {
  description = "Docker password"
}
variable "subnet" {
  description = "Subnet for standalone task"
}
variable "security_group" {
  description = "Security Group"
}

variable "redis_address" {
  description = "Address of the redis server"
}
variable "git_token" {
  description = "Github Token"
}

variable "database_host_title" {
  description = "Refernce for ENV since dynamic script"
}

variable "database_password_title" {
  description = "Refernce for ENV since dynamic script"
}

