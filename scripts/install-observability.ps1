# Install Prometheus + Grafana (kube-prometheus-stack) and portfolio dashboard
# Requires: helm, kubectl
# On minikube/kind: use --timeout 15m; admission webhook jobs can be slow.

$ErrorActionPreference = "Stop"

Write-Host "Installing kube-prometheus-stack (Prometheus + Grafana)..." -ForegroundColor Cyan
Write-Host "This may take 5-10 minutes on local clusters (minikube/kind)." -ForegroundColor Gray

# Check helm
if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    Write-Host "helm is required. Install from https://helm.sh" -ForegroundColor Red
    exit 1
}

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>$null
helm repo update

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack `
  -n monitoring --create-namespace `
  --set grafana.sidecar.dashboards.enabled=true `
  --timeout 15m

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nHelm install had issues. If admission-patch timed out, the stack may still work." -ForegroundColor Yellow
    Write-Host "Check: kubectl get pods -n monitoring" -ForegroundColor Yellow
}

Write-Host "`nWaiting for pods (up to 3 min)..." -ForegroundColor Cyan
kubectl wait -n monitoring --for=condition=ready pod -l app.kubernetes.io/name=grafana --timeout=180s 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "Grafana not ready yet. Run: kubectl get pods -n monitoring" -ForegroundColor Yellow }
kubectl wait -n monitoring --for=condition=ready pod -l app.kubernetes.io/name=prometheus --timeout=180s 2>$null

Write-Host "`nApplying portfolio Grafana dashboard ConfigMap..." -ForegroundColor Cyan
kubectl apply -f (Join-Path $PSScriptRoot "..\k8s\observability\grafana-dashboard-configmap.yaml")

Write-Host "`nDone. Access Grafana:" -ForegroundColor Green
Write-Host "  kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80"
Write-Host "  Open http://localhost:3000  (admin / prom-operator)"
Write-Host "`nIf cluster disconnected (EOF): restart it (e.g. minikube start) and retry port-forward."
Write-Host "See docs/OBSERVABILITY.md for full guide."
