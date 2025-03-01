output "manager_status" {
  value = digitalocean_droplet.manager.status 
}

output "manager_ip" {
  value = digitalocean_droplet.manager.ipv4_address
}

output "worker_status" {
  value = digitalocean_droplet.worker[*].status
}

output "worker_ip" {
  value = digitalocean_droplet.worker[*].ipv4_address
}
