data "aws_vpc" "mainvpc" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "mysql_test_db_sg" {
  name        = "mysql_test_db_sg"
  description = "Rules for load my db server"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = "${var.my_ips}"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${data.aws_vpc.mainvpc.cidr_block}"] # I want this to be accessible for all VMs in the same VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
