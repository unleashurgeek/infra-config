apiVersion: v1
kind: Namespace
metadata:
  name: argocd
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: argocd
  namespace: argocd
spec:
  chart: argo-cd
  repo: https://argoproj.github.io/argo-helm
  version: 5.41.1
  targetNamespace: argocd
  valuesContent: |-
    configs:
      params:
        server.insecure: true
        server.rootpath: '/ci'
---
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: argocd-server
  namespace: argocd
spec:
  routes:
  - match: PathPrefix(`/ci`)
    kind: Rule
    priority: 10
    services:
    - name: argocd-server
      port: 80
  - match: PathPrefix(`/ci`) && Headers(`Content-Type`, `application/grpc`)
    kind: Rule
    priority: 11
    services:
    - name: argocd-server
      port: 80
      scheme: h2c
