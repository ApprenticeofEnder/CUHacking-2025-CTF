variable "do_token" { sensitive = true }
variable "ssh_user" {
  default = "root"
}
variable "public_key_path" {
  default = "cuhacking_ctf.pub"
}
variable "private_key_path" {
  default = "cuhacking_ctf.pem"
}
variable "postgres_password" {
  default = "postgres"
}