#!/usr/bin/env bash
# Deploy k8s manifests from your machine using your local kubeconfig.
# Usage: ./deploy.sh [optional-image]
# Example: ./deploy.sh ghcr.io/asadyare/portfolio-frontend:latest

set -e
IMAGE="${1:-ghcr.io/asadyare/portfolio-frontend:latest}"

echo "Using kubeconfig: ${KUBECONFIG:-$HOME/.kube/config}"
echo ""
echo "Verifying cluster connection..."
kubectl cluster-info

echo ""
echo "Applying manifests from k8s/ ..."
kubectl apply -f k8s/ -R

echo ""
echo "Setting deployment image to: $IMAGE"
kubectl set image deployment/portfolio app="$IMAGE" -n portfolio

echo ""
echo "Done."
