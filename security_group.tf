# It's important to have different security groups for the different projects because if we want to destroy everything
# (Terraform destroy), then it will delete the security group as well and it could be used by another instance...
# This is why it could possibly be better to define the security group rules inline within the security groups
data "aws_vpc" "mainvpc" {
  id = "${var.vpc_id}"
}

# HTTP access 
resource "aws_security_group" "allow_port_80_sg" {
  name        = "allow_port_80_sg"
  description = "Allow ingress traffic through port 80"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_port_80" {
  security_group_id = "${aws_security_group.allow_port_80_sg.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ips}"]
}

# All the resources below are defined as separate resources
# Default egress - allows any egress traffic
resource "aws_security_group" "default_egress_sg" {
  name        = "default_egress"
  description = "Default Egress"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "default_egress" {
  security_group_id = "${aws_security_group.default_egress_sg.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Administrative Access
resource "aws_security_group" "admin_access_sg" {
  name        = "admin_access"
  description = "Admin Access"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "admin_ssh" {
  security_group_id = "${aws_security_group.admin_access_sg.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "admin_icmp" {
  security_group_id = "${aws_security_group.admin_access_sg.id}"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# VPC - Internal access
resource "aws_security_group" "internal_access_vpc_sg" {
  name        = "internal_access_vpc"
  description = "Allow all ingress traffic from all devices in the same VPC"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "internal_access_vpc" {
  security_group_id = "${aws_security_group.internal_access_vpc_sg.id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${data.aws_vpc.mainvpc.cidr_block}"]            # I want this to be accessible for all VMs in the same VPC
}
