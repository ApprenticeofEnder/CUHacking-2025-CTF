data "digitalocean_kubernetes_versions" "list" {
  version_prefix = "1.31."
}

resource "digitalocean_kubernetes_cluster" "ctf_k8s" {
  name    = "cuhacking-2025-ctf-k8s"
  region  = "tor1"
  version = data.digitalocean_kubernetes_versions.list.latest_version

  node_pool {
    name       = "cuhacking-ctf-np"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 3
  }
}

data "digitalocean_domain" "robertbabaev_tech" {
  name = "robertbabaev.tech"
}

output "cluster_ip" {
   value = digitalocean_kubernetes_cluster.ctf_k8s.ipv4_address 
}

resource "digitalocean_record" "cuhacking_ctf" {
  domain = data.digitalocean_domain.robertbabaev_tech.id
  type   = "A"
  name   = "cuhacking-ctf"
  value  = "${digitalocean_kubernetes_cluster.ctf_k8s.ipv4_address}"
}

resource "digitalocean_project" "cuhacking_ctf" {
  name        = "CUHacking 2025 CTF"
  description = "Resources for the CUHacking 2025 CTF"
  purpose     = "Other"
  environment = "Development"
  resources   = [digitalocean_kubernetes_cluster.ctf_k8s.urn]
}
