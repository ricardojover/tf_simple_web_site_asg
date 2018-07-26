# All these variables will be passed outside the module.
variable "user_data" {}

variable "image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "cluster_name" {}

variable security_groups_lc {
  type    = "list"
  default = []
}

variable security_groups_elb {
  type    = "list"
  default = []
}

variable "min_size" {}
variable "max_size" {}
variable "desired_capacity" {}

variable "availability_zones" {
  type    = "list"
  default = []
}

variable "http_port" {}
