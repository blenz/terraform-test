output "app_name" {
  value = "${var.app_name}-${terraform.workspace}"
}

output "app_ip_addr" {
  value = digitalocean_loadbalancer.loadbalancer.ip
}
