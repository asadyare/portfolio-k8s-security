#!/usr/bin/env bash
set -e

REPO_NAME="portfolio-k8s-security"
GITHUB_USER="asadyare"

mkdir -p docker
mkdir -p k8s/base
mkdir -p k8s/ingress
mkdir -p k8s/security
mkdir -p k8s/observability
mkdir -p ci

cat > README.md <<EOF
# portfolio-k8s-security

Kubernetes security focused project for DevSecOps portfolio.

Stack
Kubernetes
Docker
Node.js
Nginx Ingress
Trivy
kube-bench
kube-linter
Prometheus
Grafana
GitHub Actions
EOF

cat > docker/Dockerfile <<EOF
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node","app.js"]
EOF

cat > k8s/base/namespace.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: portfolio
EOF

cat > k8s/base/deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app
  namespace: portfolio
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-app
  template:
    metadata:
      labels:
        app: node-app
    spec:
      containers:
      - name: app
        image: node-app:latest
        ports:
        - containerPort: 3000
EOF

cat > k8s/base/service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: node-app
  namespace: portfolio
spec:
  selector:
    app: node-app
  ports:
  - port: 80
    targetPort: 3000
EOF

cat > k8s/base/configmap.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: portfolio
data:
  NODE_ENV: production
EOF

cat > k8s/base/secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: portfolio
type: Opaque
stringData:
  API_KEY: example
EOF

cat > k8s/ingress/ingress.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: portfolio
spec:
  ingressClassName: nginx
  rules:
  - host: app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: node-app
            port:
              number: 80
EOF

cat > k8s/security/pod-security.yaml <<EOF
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: node-app-pdb
  namespace: portfolio
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: node-app
EOF

cat > k8s/security/network-policy.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: portfolio
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

cat > k8s/security/resource-quota.yaml <<EOF
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: portfolio
spec:
  hard:
    pods: "10"
    requests.cpu: "2"
    requests.memory: 2Gi
EOF

cat > k8s/observability/prometheus.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: portfolio
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
EOF

cat > k8s/observability/grafana.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-config
  namespace: portfolio
data:
  grafana.ini: |
    [auth.anonymous]
    enabled = true
EOF

cat > ci/github-actions.yaml <<EOF
name: k8s-security

on:
  push:
    branches: [ main ]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Trivy scan
      uses: aquasecurity/trivy-action@0.20.0
      with:
        scan-type: fs
        severity: HIGH,CRITICAL
    - name: kube-bench
      run: echo "Run kube-bench here"
    - name: kube-linter
      run: echo "Run kube-linter here"
EOF

git init
git add .
git commit -m "Initial Kubernetes security portfolio setup"
git branch -M main

gh repo create "$REPO_NAME" --public --source=. --remote=origin --push