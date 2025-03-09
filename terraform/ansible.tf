resource "time_sleep" "wait_manager" {
  depends_on = [digitalocean_droplet.manager]

  create_duration = "30s"
}

resource "time_sleep" "wait_workers" {
  depends_on = [digitalocean_droplet.workers.0]

  create_duration = "30s"
}

locals {
  ini_file = "${path.module}/${var.ansible_ini_file}"
  raw_vault_file = "/tmp/vault.yml"
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
  output_file = local.ini_file
}

module "ansible_vault_raw" {
  source = "${path.module}/modules/saved_file"

  file_contents = templatefile(
    "${path.module}/templates/vault.yml.tftpl",
    {
      image_registry_username = var.image_registry_username
      image_registry_password = var.image_registry_password
      postgres_password = var.postgres_password
      postgres_db = var.postgres_db
    }
  )
  output_file = local.raw_vault_file 
}

resource "null_resource" "ansible_vault" {
  triggers = {
    timestamp = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/external/create_ansible_vault.sh ${module.ansible_vault_raw.file_path}" 
  }

  depends_on = [module.ansible_vault_raw]
}
