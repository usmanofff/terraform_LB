output "ya_instance_1" {
  value = module.ya_instance_1
}
output "ya_instance_2" {
  value = module.ya_instance_2
}

output "external_LB" {
  value = yandex_lb_network_load_balancer.yandex_LB.listener
}
