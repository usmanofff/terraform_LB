terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

}

provider "yandex" {
  token     = var.user_data.token
  cloud_id  = var.user_data.cloud_id
  folder_id = var.user_data.folder_id
  zone      = var.region
}

resource "yandex_vpc_network" "my_vpc" {
  name        = "vpc_1"
  description = "vpc for server Lemp and Lamp"
}

resource "yandex_vpc_subnet" "subnet_1" {
  name           = "10.1.1.0/24"
  v4_cidr_blocks = ["10.1.1.0/24"]
  network_id     = yandex_vpc_network.my_vpc.id

}
resource "yandex_vpc_subnet" "subnet_2" {
  name           = "10.2.2.0/24"
  v4_cidr_blocks = ["10.2.2.0/24"]
  network_id     = yandex_vpc_network.my_vpc.id

}

resource "yandex_lb_target_group" "target_group" {
  name = "my-target-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet_1.id
    address   = module.ya_instance_1.internal_ip
  }
  target {
    subnet_id = yandex_vpc_subnet.subnet_2.id
    address   = module.ya_instance_2.internal_ip
  }

}

resource "yandex_lb_network_load_balancer" "yandex_LB" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target_group.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}


data "yandex_compute_image" "lemp" {
  family = "lemp"
}
data "yandex_compute_image" "lamp" {
  family = "lamp"
}


module "ya_instance_1" {
  source    = "./modules"
  name      = "lemp"
  subnet_id = yandex_vpc_subnet.subnet_1.id
  image_id  = data.yandex_compute_image.lemp.id
}


module "ya_instance_2" {
  source    = "./modules"
  name      = "lamp"
  subnet_id = yandex_vpc_subnet.subnet_2.id
  image_id  = data.yandex_compute_image.lamp.id
}

