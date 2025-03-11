# Database Variables
variable "postgres_capacity" {
  default = "10Gi"
}

variable "postgres_hostname" {
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

variable "ansible_vault_password_file" {
  type = string
  default = "vars/vault.secret"
}
