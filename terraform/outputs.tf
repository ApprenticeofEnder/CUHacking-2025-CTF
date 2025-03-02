output "manager_status" {
  value = digitalocean_droplet.manager.status 
}

output "manager_ip" {
  value = digitalocean_droplet.manager.ipv4_address
}

output "worker_status" {
  value = digitalocean_droplet.workers[*].status
}

output "worker_ip" {
  value = digitalocean_droplet.workers[*].ipv4_address
}

output "ansible_ini_file" {
  value = local.ansible_ini_file
}

output "ansible_ini_content" {
  value = local.ansible_ini_content
}
