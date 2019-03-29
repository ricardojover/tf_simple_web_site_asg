module "simple_web_site_asg_module" {
  source = "asg" # directory that contains the module (relative path)

  cluster_name        = "${var.cluster_name}"
  instance_type       = "${var.instance_type}"
  key_name            = "${var.key_name}"
  min_size            = "${var.aws_autoscaling_group_min_size}"
  max_size            = "${var.aws_autoscaling_group_max_size}"
  security_groups_lc  = ["${aws_security_group.admin_access_sg.id}", "${aws_security_group.internal_access_vpc_sg.id}", "${aws_security_group.default_egress_sg.id}"]
  security_groups_elb = ["${aws_security_group.admin_access_sg.id}", "${aws_security_group.allow_port_80_sg.id}", "${aws_security_group.default_egress_sg.id}"]
  user_data           = "${data.template_file.simple_web_site.rendered}"
  image_id            = "${data.aws_ami.ubuntu.id}"
  min_size            = "${var.aws_autoscaling_group_min_size}"
  max_size            = "${var.aws_autoscaling_group_max_size}"
  desired_capacity    = "${var.aws_autoscaling_group_desired_capacity}"
  availability_zones  = ["${data.aws_availability_zones.available_az.names}"]
  http_port           = "${var.http_port}"
}
