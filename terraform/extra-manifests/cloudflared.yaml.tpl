apiVersion: v1
kind: Namespace
metadata:
  name: cloudflared
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloudflared
  namespace: cloudflared
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cloudflared
  template:
    metadata:
      labels:
        app: cloudflared

    spec:
      containers:
      - name: cloudflared
        image: cloudflare/cloudflared:2023.7.1
        args: ["tunnel", "--config", "/etc/cloudflared/config/config.yaml", "run"]

        resources:
          requests:
            cpu: 250m
            memory: 64Mi
          limits:
            cpu: 500m
            memory: 128Mi

        livenessProbe:
          httpGet:
            path: /ready
            port: 2000
          failureThreshold: 1
          initialDelaySeconds: 10
          periodSeconds: 10

        volumeMounts:
        - name: config
          mountPath: /etc/cloudflared/config
          readOnly: true
        - name: creds
          mountPath: /etc/cloudflared/creds
          readOnly: true

      volumes:
      - name: creds
        secret:
          secretName: cloudflared
      - name: config
        configMap:
          name: cloudflared
---
apiVersion: v1
kind: Secret
metadata:
  name: cloudflared
  namespace: cloudflared
stringData:
  credentials.json: |
    {
      "AccountTag": "${cloudflare_account_id}",
      "TunnelID": "${tunnel_id}",
      "TunnelName": "${tunnel_name}",
      "TunnelSecret": "${tunnel_secret}"
    }
