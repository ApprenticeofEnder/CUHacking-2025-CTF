data "digitalocean_kubernetes_versions" "list" {
  version_prefix = "1.31."
}

resource "digitalocean_kubernetes_cluster" "ctf_k8s" {
  name    = "cuhacking_2025_ctf_k8s"
  region  = "tor1"
  version = data.digitalocean_kubernetes_versions.list.latest_version

  node_pool {
    name       = "default-np"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 3
  }
}

resource "digitalocean_project" "cuhacking_ctf" {
  name        = "CUHacking 2025 CTF"
  description = "Resources for the CUHacking 2025 CTF"
  purpose     = "Other"
  environment = "Development"
  resources   = [digitalocean_kubernetes_cluster.ctf_k8s.urn]
}