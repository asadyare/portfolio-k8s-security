# Install Prometheus + Grafana (kube-prometheus-stack) and portfolio dashboard
# Requires: helm, kubectl

$ErrorActionPreference = "Stop"

Write-Host "Installing kube-prometheus-stack (Prometheus + Grafana)..." -ForegroundColor Cyan

# Check helm
if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    Write-Host "helm is required. Install from https://helm.sh" -ForegroundColor Red
    exit 1
}

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>$null
helm repo update

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack `
  -n monitoring --create-namespace `
  --set grafana.sidecar.dashboards.enabled=true

Write-Host "`nWaiting for pods to be ready..." -ForegroundColor Cyan
kubectl wait -n monitoring --for=condition=ready pod -l app.kubernetes.io/name=grafana --timeout=120s 2>$null
kubectl wait -n monitoring --for=condition=ready pod -l app.kubernetes.io/name=prometheus --timeout=120s 2>$null

Write-Host "`nApplying portfolio Grafana dashboard ConfigMap..." -ForegroundColor Cyan
kubectl apply -f (Join-Path $PSScriptRoot "..\k8s\observability\grafana-dashboard-configmap.yaml")

Write-Host "`nDone. Access Grafana:" -ForegroundColor Green
Write-Host "  kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80"
Write-Host "  Open http://localhost:3000  (admin / prom-operator)"
Write-Host "`nSee docs/OBSERVABILITY.md for full guide."
