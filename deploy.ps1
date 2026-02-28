# Deploy k8s manifests from your machine using your local kubeconfig.
# Usage: .\deploy.ps1 [optional-image]
# Example: .\deploy.ps1 ghcr.io/asadyare/portfolio-frontend:latest

param(
    [string]$Image = "ghcr.io/asadyare/portfolio-frontend:latest"
)

$ErrorActionPreference = "Stop"

Write-Host "Using kubeconfig: $env:KUBECONFIG" -ForegroundColor Cyan
if (-not $env:KUBECONFIG) { Write-Host "  (default: $env:USERPROFILE\.kube\config)" -ForegroundColor Gray }

Write-Host "`nVerifying cluster connection..." -ForegroundColor Cyan
kubectl cluster-info
if ($LASTEXITCODE -ne 0) {
    Write-Host "Cannot reach cluster. Check that your cluster is running and KUBECONFIG is set." -ForegroundColor Red
    exit 1
}

Write-Host "`nApplying manifests from k8s/ ..." -ForegroundColor Cyan
kubectl apply -f k8s/ -R
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "`nSetting deployment image to: $Image" -ForegroundColor Cyan
kubectl set image deployment/portfolio app=$Image -n portfolio

Write-Host "`nDone." -ForegroundColor Green
