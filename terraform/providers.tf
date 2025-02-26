terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }

  backend "s3" {
    endpoint                    = "https://tor1.digitaloceanspaces.com"
    region                      = "us-west-1" # Just a placeholder, not used
    key                         = "cuhacking-2025/terraform/terraform.tfstate"
    bucket                      = "rbabaev-terraform-storage"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
}
