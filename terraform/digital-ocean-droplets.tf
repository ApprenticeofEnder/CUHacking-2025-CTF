data "digitalocean_ssh_key" "cuhacking" {
  name = "CUHacking2025"
}

resource "digitalocean_droplet" "manager" {
  name     = "manager"
  size     = "s-1vcpu-2gb"
  image    = "ubuntu-22-04-x64"
  region   = "tor1"
  ssh_keys = [data.digitalocean_ssh_key.cuhacking.id]
}

resource "digitalocean_droplet" "workers" {
  count    = 2
  name     = "worker-${count.index}"
  size     = "s-1vcpu-2gb"
  image    = "ubuntu-22-04-x64"
  region   = "tor1"
  ssh_keys = [data.digitalocean_ssh_key.cuhacking.id]
}

locals {
  droplet_ids  = concat([digitalocean_droplet.manager.id], [for s in digitalocean_droplet.workers.*.id : s])
  droplet_urns = concat([digitalocean_droplet.manager.urn], [for s in digitalocean_droplet.workers.*.urn : s])
}

resource "digitalocean_firewall" "ctf" {
  name = "docker-swarm-firewall"

  droplet_ids = local.droplet_ids

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "2377"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "7946"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "7946"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "4789"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_project" "cuhacking_ctf" {
  name        = "CUHacking 2025 CTF"
  description = "Resources for the CUHacking 2025 CTF"
  purpose     = "Other"
  environment = "Development"
  resources   = concat(local.droplet_urns, [digitalocean_firewall.ctf.urn])
}


# resource "digitalocean_record" "cuhacking_ctf" {
#   domain = data.digitalocean_domain.robertbabaev_tech.id
#   type   = "A"
#   name   = "cuhacking-ctf"
#   value  = "${digitalocean_kubernetes_cluster.ctf_k8s.ipv4_address}"
# }

# resource "digitalocean_project" "cuhacking_ctf" {
#   name        = "CUHacking 2025 CTF"
#   description = "Resources for the CUHacking 2025 CTF"
#   purpose     = "Other"
#   environment = "Development"
#   resources   = [digitalocean_kubernetes_cluster.ctf_k8s.urn]
# }
