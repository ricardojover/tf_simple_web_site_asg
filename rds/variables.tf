variable "db_name" {
  default = "MyDB"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  description = "Password for the MySQL DB" # This will be passed in an environment variable
}

variable "vpc_id" {
  description = "The ID of the virtual private cloud (VPC) the security group belongs to"
}

variable "my_ips" {
  description = "This is just my IP... It's dynamic so I will need to change it..."
  default     = []
}

variable "aws_region" {}
