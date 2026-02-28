# Install NGINX Ingress Controller
# See https://kubernetes.github.io/ingress-nginx/deploy/

$ErrorActionPreference = "Stop"

Write-Host "Installing NGINX Ingress Controller..." -ForegroundColor Cyan

# Minikube: use addon (recommended)
if (Get-Command minikube -ErrorAction SilentlyContinue) {
    try {
        minikube status | Out-Null
        Write-Host "Minikube detected. Enabling ingress addon..." -ForegroundColor Cyan
        minikube addons enable ingress
        Write-Host "Done. Allow a minute for pods to be ready: kubectl get pods -n ingress-nginx" -ForegroundColor Green
        exit 0
    } catch {}
}

# Otherwise apply official manifest (works for kind, Docker Desktop, cloud)
$Manifest = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.3/deploy/static/provider/cloud/deploy.yaml"
Write-Host "Applying $Manifest" -ForegroundColor Cyan
kubectl apply -f $Manifest

Write-Host "Done. Wait for controller: kubectl wait -n ingress-nginx --for=condition=ready pod -l app.kubernetes.io/component=controller --timeout=120s" -ForegroundColor Green
Write-Host "Get external IP: kubectl get svc -n ingress-nginx ingress-nginx-controller" -ForegroundColor Green
