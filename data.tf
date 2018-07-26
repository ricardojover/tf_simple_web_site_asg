data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "simple_web_site" {
  template = "${file("${path.module}/scripts/simple_web_site.sh")}"

  vars {
    db_address = "${data.terraform_remote_state.db.address}"
    db_port    = "${data.terraform_remote_state.db.port}"
    http_port  = "${var.http_port}"
    version    = "${var.version}"
  }
}

data "aws_availability_zones" "available_az" {}

data "terraform_remote_state" "db" {
  backend = "local"

  config {
    path = "rds/terraform.tfstate"
  }
}
