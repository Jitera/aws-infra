

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "env" {
  description = "Environment that is used as placeholder"
  default     = ""
}

variable "database_name" {
  description = "Name of database name"
  default     = ""
}

variable "user" {
  description = "Name of database user"
  default     = ""
}

variable "password" {
  description = "Name of database password"
  default     = ""
}

variable "subnets" {
  description = "A list of subnets to set db"
  default     = []
}

variable "security_groups" {
  description = "A list of security group ids for db"
  default     = []
}
variable "snapshot_identifier" {
  description = "A list of security group ids for db"
  default     = []
}
