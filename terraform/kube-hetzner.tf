module "kube-hetzner" {
  source = "kube-hetzner/kube-hetzner/hcloud"
  providers = {
    hcloud = hcloud
  }

  hcloud_token = var.hcloud_token

  # only used for first run
  ssh_public_key  = file("~/.ssh/id_ed25519.pub")
  ssh_private_key = file("~/.ssh/id_ed25519")

  # https://docs.hetzner.com/cloud/general/locations/
  network_region = "us-west" # hil

  control_plane_nodepools = [
    {
      name        = "control-plane",
      server_type = "cpx11"
      location    = "hil",
      labels      = [],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name        = "agent-small",
      server_type = "cpx11",
      location    = "hil",
      labels      = [],
      taints      = [],
      count       = 2
    }
  ]

  # encrypt traffic in CNI using wireguard
  enable_wireguard = true

  # use KlipperLB instead of HetznerLB which costs
  # this also makes pods schedule to the control nodes
  enable_klipper_metal_lb = true

  # only enable if control is HA
  automatically_upgrade_os = false

  # do not want to generate these files, build focused on automation
  create_kubeconfig    = false
  create_kustomization = false

  # used by extra-manifests for kustomize deployments
  extra_kustomize_parameters = {
    tunnel_id             = cloudflare_tunnel.kube_hetzner_tunnel.id,
    tunnel_name           = cloudflare_tunnel.kube_hetzner_tunnel.name,
    tunnel_secret         = random_id.tunnel_secret.b64_std,
    cloudflare_account_id = var.cloudflare_account_id
  }

  extra_firewall_rules = [
    {
      description     = "Allow Outbound UDP Cloudflared"
      direction       = "out"
      protocol        = "udp"
      port            = "7844"
      source_ips      = []
      destination_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      description     = "Allow Outbound TCP Cloudflared"
      direction       = "out"
      protocol        = "tcp"
      port            = "7844"
      source_ips      = []
      destination_ips = ["0.0.0.0/0", "::/0"]
    }
  ]

  # traefik settings. autscaling not needed at this scale
  traefik_autoscaling = false
}
