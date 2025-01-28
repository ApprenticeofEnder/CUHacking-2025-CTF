resource "digitalocean_droplet" "leader" {
  name     = "leader"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-22-04-x64"
  region   = "nyc3"
  ssh_keys = ["45132344"]
}

resource "digitalocean_droplet" "workers" {
  count    = 2
  name     = "worker-${count.index}"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-22-04-x64"
  region   = "nyc3"
  ssh_keys = ["45132344"]
}

resource "digitalocean_firewall" "ctf" {
  name = "docker-swarm-firewall"

  droplet_ids = concat([digitalocean_droplet.leader.id], [for s in digitalocean_droplet.workers.*.id : s])

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
  resources   = concat([digitalocean_droplet.leader.urn], [for s in digitalocean_droplet.workers.*.urn : s])
}
