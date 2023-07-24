terraform {
  required_version = ">= 1.4.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.41.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "random" {}
