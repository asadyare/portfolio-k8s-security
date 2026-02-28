# Install cert-manager for TLS (Let's Encrypt)
# See https://cert-manager.io/docs/installation/

param([string]$Version = "v1.14.4")

$ErrorActionPreference = "Stop"
$Manifest = "https://github.com/cert-manager/cert-manager/releases/download/$Version/cert-manager.yaml"

Write-Host "Installing cert-manager $Version..." -ForegroundColor Cyan
kubectl apply -f $Manifest

Write-Host "Waiting for cert-manager to be ready..." -ForegroundColor Cyan
kubectl wait -n cert-manager --for=condition=ready pod -l app.kubernetes.io/instance=cert-manager --timeout=120s 2>$null

Write-Host "Done. Create a ClusterIssuer for Let's Encrypt so the Ingress TLS secret is issued." -ForegroundColor Green
