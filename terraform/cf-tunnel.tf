resource "random_id" "tunnel_secret" {
  byte_length = 35

}

resource "cloudflare_tunnel" "kube_hetzner_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "Hetzner Kube Tunnel"
  secret     = random_id.tunnel_secret.b64_std
  config_src = "local"
}
