resource "ansible_group" "manager" {
  name     = "manager"
  children = [digitalocean_droplet.manager.ipv4_address]
  variables = {
    ansible_user                 = var.ansible_ssh_user
    ansible_ssh_private_key_file = var.ansible_ssh_private_key_file
  }
  depends_on = [time_sleep.wait_20_seconds]
}

resource "ansible_group" "worker" {
  name     = "worker"
  children = [digitalocean_droplet.workers.*.ipv4_address]
  variables = {
    ansible_user                 = var.ansible_ssh_user
    ansible_ssh_private_key_file = var.ansible_ssh_private_key_file
  }
  depends_on = [time_sleep.wait_20_seconds]
}

resource "terraform_data" "ansible_inventory" {
  provisioner "local-exec" {
    command = "ansible-inventory -i inventory.yml --graph --vars"
  }
  depends_on = [ansible_group.manager, ansible_group.worker]
}

resource "terraform_data" "docker_playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yml playbooks/docker.yml"
  }
  depends_on = [terraform_data.ansible_inventory]
}

resource "terraform_data" "swarm_playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yml playbooks/swarm.yml"
  }
  depends_on = [terraform_data.docker_playbook]
}

