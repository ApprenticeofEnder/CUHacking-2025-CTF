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
      worker_ips = digitalocean_droplet.worker[*].ipv4_address
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



resource "ansible_playbook" "docker_playbook" {
  name = "all"
  playbook = "playbooks/docker.yml"
  depends_on = [time_sleep.wait_workers]
}

# resource "terraform_data" "swarm_playbook" {
#   provisioner "local-exec" {
#     command = "ansible-playbook -i inventory.yml playbooks/swarm.yml"
#   }
#   depends_on = [terraform_data.docker_playbook]
# }
#
# locals {
#   deploy_vars_json = jsonencode({
#     image_registry_username = var.image_registry_username
#     image_registry_password = var.image_registry_password
#     postgres_password = var.postgres_password
#   })
# }
#
# resource "terraform_data" "deploy_playbook" {
#   provisioner "local-exec" {
#     command = "ansible-playbook -i inventory.yml playbooks/deploy.yml --extra-vars '${local.deploy_vars_json}'"
#   }
#   depends_on = [terraform_data.docker_playbook]
# }
