resource "null_resource" "ansible-provision" {
  depends_on = [digitalocean_droplet.leader, digitalocean_droplet.workers]

  provisioner "local-exec" {
    command = "echo \"[swarm_leader]\" > ${path.module}/../ansible-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"${format("%s ansible_ssh_user=%s", digitalocean_droplet.leader.ipv4_address, var.ssh_user)}\" >> ${path.module}/../ansible-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"[swarm_workers]\" >> ${path.module}/../ansible-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_user=%s", digitalocean_droplet.workers.*.ipv4_address, var.ssh_user))}\" >> ${path.module}/../ansible-inventory"
  }
}