output "elb_dns_name" {
  value = "${module.simple_web_site_asg_module.elb_dns_name}"
}
