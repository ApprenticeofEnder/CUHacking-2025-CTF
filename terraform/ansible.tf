resource "time_sleep" "wait_manager" {
  depends_on = [digitalocean_droplet.manager]

  create_duration = "30s"
}

resource "time_sleep" "wait_workers" {
  depends_on = [digitalocean_droplet.workers.0]

  create_duration = "30s"
}

module "ansible_ini" {
  source = "${path.module}/modules/saved_file"

  file_contents = templatefile(
    "${path.module}/templates/inventory.ini.tftpl",
    {
      manager_ips                  = [digitalocean_droplet.manager.ipv4_address]
      worker_ips                   = digitalocean_droplet.workers[*].ipv4_address
      ansible_user                 = var.ansible_ssh_user
      ansible_ssh_private_key_file = var.ansible_ssh_private_key_file
    }
  )
  output_file = "${path.module}/${var.ansible_ini_file}"
}

module "ansible_vault" {
  source = "${path.module}/modules/saved_file"

  file_contents = templatefile(
    "${path.module}/templates/vault.yml.tftpl",
    {
      image_registry_username = var.image_registry_username
      image_registry_password = var.image_registry_password
    }
  )
  output_file = "${path.module}/${var.ansible_vault_file}"
}


