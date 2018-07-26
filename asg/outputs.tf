# OUTPUTS
output "elb_dns_name" {
  value = "${aws_elb.simple_web_site_cluster_elb.dns_name}"
}
