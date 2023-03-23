output "internal_ip" {
  value = yandex_compute_instance.web_server.network_interface[0].ip_address
}
output "external_ip" {
  value = "${yandex_compute_instance.web_server.network_interface[0].nat_ip_address}"
}
