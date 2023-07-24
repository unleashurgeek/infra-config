apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- cloudflared.yaml
- argocd.yaml

configMapGenerator:
- name: cloudflared
  namespace: cloudflared
  files:
  - config.yaml=cloudflared-config.yaml
