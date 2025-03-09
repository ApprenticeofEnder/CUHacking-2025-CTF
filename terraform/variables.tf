# Database Variables
variable "postgres_capacity" {
  default = "10Gi"
}

variable "postgres_app_name" {
  default = "postgres"
}

variable "postgres_db" {
  default = "pilots"
}

variable "postgres_user" {
  default = "postgres"
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

# Challenge Variables
variable "challenge_app_name" {
  default = "challenge"
}

variable "image_registry" {
  default = "ghcr.io"
}

variable "image_registry_username" {
  type      = string
  sensitive = true
}

variable "image_registry_password" {
  type      = string
  sensitive = true
}

variable "challenge_image_name" {
  default = "apprenticeofender/cuhacking-2025-ctf"
}

variable "challenge_image_tag" {
  default = "latest"
}

variable "challenge_port" {
  default = 3000
}

# Ansible Variables
variable "ansible_ssh_user" {
  type    = string
  default = "root"
}

variable "ansible_ssh_private_key_file" {
  type = string
}

variable "ansible_ini_file" {
  type    = string
  default = "inventory.ini"
}

variable "ansible_vault_file" {
  type    = string
  default = "vars/vault.yml"
}

variable "ansible_vault_password_file" {
  type = string
  default = "vars/vault.secret"
}
