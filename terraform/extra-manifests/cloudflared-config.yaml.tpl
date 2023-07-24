tunnel: ${tunnel_id}
credentials-file: /etc/cloudflared/creds/credentials.json
metrics: 0.0.0.0:2000
no-autoupdate: true
ingress:
- service: https://traefik.traefik.svc.cluster.local.:443
  originRequest:
    noTLSVerify: true
    http2Origin: true
