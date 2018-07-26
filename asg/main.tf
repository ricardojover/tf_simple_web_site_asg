# Launch configuration for my first cluster
# In the launch configuration we define the instance we want to create. E.g. Ubuntu, CoreOS, EC2...
resource "aws_launch_configuration" "simple_web_site_cluster_lc" {
  name_prefix     = "${var.cluster_name}-lc-"
  image_id        = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${var.security_groups_lc}"]
  user_data       = "${var.user_data}"

  lifecycle {
    create_before_destroy = true # Terraform will first create a new Launch Configuration, wait for it to come up, and then remove the old one.
  }
}

resource "aws_autoscaling_group" "simple_web_site_cluster_asg" {
  # For zero-downtime deployment, this name must depend on the name of the launch configuration.
  name = "${aws_launch_configuration.simple_web_site_cluster_lc.name}-asg"

  #name = "${var.cluster_name}-asg"
  launch_configuration = "${aws_launch_configuration.simple_web_site_cluster_lc.id}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired_capacity}"
  min_elb_capacity     = "${var.min_size}"                                           # For zero-downtime deployment we match the min_elb_capacity parameter to the min_size of the cluster so that Terraform will wait for at least that many servers from the new ASG to register in the ELB before starting to destroy the original ASG.
  availability_zones   = ["${var.availability_zones}"]
  load_balancers       = ["${aws_elb.simple_web_site_cluster_elb.name}"]
  health_check_type    = "ELB"                                                       # What this does is that if one server is not responding the http request in the LB, then it'll terminate the instance and will re-create a new one

  lifecycle {
    create_before_destroy = true # This is important as we do not want this to be destroyed until the new ASG is up and running
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}" # This is not only a tag in the autoscaling group but also the name of every single instance that belongs to this ASG
    propagate_at_launch = true
  }

  tag {
    key                 = "Info"
    value               = "Managed in project tf_simple_web_site_cluster"
    propagate_at_launch = true
  }
}

resource "aws_elb" "simple_web_site_cluster_elb" {
  name               = "${var.cluster_name}-elb"      # this is the first portion in the DNS. e.g. elb-80-for-ubuntus-port-8123-1048446003.eu-west-2.elb.amazonaws.com
  availability_zones = ["${var.availability_zones}"]
  security_groups    = ["${var.security_groups_elb}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.http_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.http_port}/"
  }
}
