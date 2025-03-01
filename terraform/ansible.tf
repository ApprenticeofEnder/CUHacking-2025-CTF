resource "time_sleep" "wait_manager" {
  depends_on = [digitalocean_droplet.manager]

  create_duration = "30s"
}

resource "time_sleep" "wait_workers" {
  depends_on = [digitalocean_droplet.workers.0]

  create_duration = "30s"
}

resource "ansible_group" "manager" {
  name     = "manager"
  children = [digitalocean_droplet.manager.ipv4_address]
  variables = {
    ansible_user                 = var.ansible_ssh_user
    ansible_ssh_private_key_file = var.ansible_ssh_private_key_file
  }
  depends_on = [time_sleep.wait_manager]
}

resource "ansible_group" "worker" {
  name     = "worker"
  children = [for s in digitalocean_droplet.workers.*.ipv4_address : s]
  variables = {
    ansible_user                 = var.ansible_ssh_user
    ansible_ssh_private_key_file = var.ansible_ssh_private_key_file
  }
  depends_on = [time_sleep.wait_workers]
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
