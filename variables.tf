# VARIABLES
variable "version" {
  default = "0.0.1"
}

variable "cluster_name" {
  description = "Name of the cluster"
  default     = "simple-web-site-cluster"
}

variable "instance_type" {
  description = "Size of the instance"
}

variable "aws_region" {
  description = "AWS region will be passed in an env variable"
}

variable "key_name" {
  description = "This is the key needed to access the VM"
  type        = "string"
  default     = "ric_test_201807"
}

variable "vpc_id" {
  description = "The ID of the virtual private cloud (VPC) to which the security group belongs"
}

variable "my_ips" {
  description = "I will allow the IPs specified here..."
  type        = "list"
}

variable "http_port" {
  default = "8123"
}

variable "aws_autoscaling_group_min_size" {
  description = "The minimum number of hosts within my cluster"
  default     = "2"
}

variable "aws_autoscaling_group_max_size" {
  description = "The maximum number of hosts within my cluster"
  default     = "5"
}

variable "aws_autoscaling_group_desired_capacity" {
  description = "The number of hosts within my cluster to start with"
  default     = "3"
}
