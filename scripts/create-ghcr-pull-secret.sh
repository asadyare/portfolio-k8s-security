# Create a Kubernetes secret so the cluster can pull images from GitHub Container Registry (ghcr.io).
# Run once per cluster/namespace. Requires a GitHub PAT with read:packages.
#
# Usage:
#   export GITHUB_PAT=ghp_xxxx   # or pass as first argument
#   ./scripts/create-ghcr-pull-secret.sh
#
# Or with namespace:
#   ./scripts/create-ghcr-pull-secret.sh ghp_xxxx portfolio

set -e
GITHUB_PAT="${1:-$GITHUB_PAT}"
NAMESPACE="${2:-portfolio}"

if [ -z "$GITHUB_PAT" ]; then
  echo "Usage: GITHUB_PAT=ghp_xxx $0"
  echo "   or: $0 ghp_xxx [namespace]"
  echo "Create a PAT at https://github.com/settings/tokens with read:packages."
  exit 1
fi

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl delete secret ghcr.io-pull -n "$NAMESPACE" --ignore-not-found
kubectl create secret docker-registry ghcr.io-pull \
  --docker-server=ghcr.io \
  --docker-username=asadyare \
  --docker-password="$GITHUB_PAT" \
  -n "$NAMESPACE"

echo "Created secret ghcr.io-pull in namespace $NAMESPACE."
echo "Deployment already uses imagePullSecrets: ghcr.io-pull. Restart pods if needed:"
echo "  kubectl rollout restart deployment/portfolio -n $NAMESPACE"
