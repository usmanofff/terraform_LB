terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

}


resource "yandex_compute_instance" "web_server" {

  name = "terraform-${var.name}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "lemp:${file("~/.ssh/id_ed25519.pub")}"
  }

}

output "subnet_id" {
  value=var.subnet_id
}