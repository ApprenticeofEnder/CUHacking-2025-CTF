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

