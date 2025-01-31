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

variable "challenge_image_name" {
  default = "ApprenticeofEnder/CUHacking-2025-CTF"
}

variable "challenge_image_tag" {
  default = "latest"
}

variable "challenge_port" {
  default = 3000
}