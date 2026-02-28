# Create a Kubernetes secret so the cluster can pull images from GitHub Container Registry (ghcr.io).
# Run once per cluster/namespace. Requires a GitHub PAT with read:packages.
#
# Usage:
#   $env:GITHUB_PAT = "ghp_xxxx"
#   .\scripts\create-ghcr-pull-secret.ps1
#
# Or with namespace:
#   .\scripts\create-ghcr-pull-secret.ps1 -Token "ghp_xxxx" -Namespace portfolio

param(
    [string]$Token = $env:GITHUB_PAT,
    [string]$Namespace = "portfolio"
)

if (-not $Token) {
    Write-Host "Usage: `$env:GITHUB_PAT = 'ghp_xxx'; .\scripts\create-ghcr-pull-secret.ps1"
    Write-Host "  or: .\scripts\create-ghcr-pull-secret.ps1 -Token ghp_xxx -Namespace portfolio"
    Write-Host "Create a PAT at https://github.com/settings/tokens with read:packages."
    exit 1
}

kubectl create namespace $Namespace --dry-run=client -o yaml | kubectl apply -f -
kubectl delete secret ghcr.io-pull -n $Namespace --ignore-not-found 2>$null
kubectl create secret docker-registry ghcr.io-pull `
  --docker-server=ghcr.io `
  --docker-username=asadyare `
  --docker-password="$Token" `
  -n $Namespace

Write-Host "Created secret ghcr.io-pull in namespace $Namespace."
Write-Host "Deployment uses imagePullSecrets: ghcr.io-pull. Restart pods if needed:"
Write-Host "  kubectl rollout restart deployment/portfolio -n $Namespace"
