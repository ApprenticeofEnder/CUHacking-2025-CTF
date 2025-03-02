resource "time_sleep" "wait_manager" {
  depends_on = [digitalocean_droplet.manager]

  create_duration = "30s"
}

resource "time_sleep" "wait_workers" {
  depends_on = [digitalocean_droplet.workers.0]

  create_duration = "30s"
}

locals {
  ansible_ini_content = templatefile(
    "${path.module}/templates/inventory.ini.tftpl",
    { 
      manager_ips = [digitalocean_droplet.manager.ipv4_address] 
      worker_ips = digitalocean_droplet.workers[*].ipv4_address
      ansible_user = var.ansible_ssh_user
      ansible_ssh_private_key_file = var.ansible_ssh_private_key_file
    }
  )
}

resource "null_resource" "ansible_inventory" {
  triggers = {
    template = local.ansible_ini_content
  }

  # Render to local file on machine
  # https://github.com/hashicorp/terraform/issues/8090#issuecomment-291823613
  provisioner "local-exec" {
    command = format(
      "cat <<\"EOF\" > \"%s\"\n%s\nEOF",
      var.ansible_ini_file,
      local.ansible_ini_content
    )
  }
}

