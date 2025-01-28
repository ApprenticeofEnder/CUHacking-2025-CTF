terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "docker" {
  host     = "ssh://root@${digitalocean_droplet.leader.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "${path.module}/../cuhacking_ctf.pem"]
}