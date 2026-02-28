# Install NGINX Ingress Controller
# See https://kubernetes.github.io/ingress-nginx/deploy/

set -e

echo "Installing NGINX Ingress Controller..."

# Minikube: use addon (recommended)
if command -v minikube &>/dev/null && minikube status &>/dev/null; then
  echo "Minikube detected. Enabling ingress addon..."
  minikube addons enable ingress
  echo "Done. Allow a minute for pods to be ready: kubectl get pods -n ingress-nginx"
  exit 0
fi

# Otherwise apply official manifest (works for kind, Docker Desktop, cloud)
# For kind: LoadBalancer may stay Pending; use port-forward or NodePort.
MANIFEST="https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.3/deploy/static/provider/cloud/deploy.yaml"
echo "Applying $MANIFEST"
kubectl apply -f "$MANIFEST"

echo "Done. Wait for controller to be ready: kubectl wait -n ingress-nginx --for=condition=ready pod -l app.kubernetes.io/component=controller --timeout=120s"
echo "Get external IP/host: kubectl get svc -n ingress-nginx ingress-nginx-controller"
