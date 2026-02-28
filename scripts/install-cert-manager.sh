# Install cert-manager for TLS (Let's Encrypt)
# See https://cert-manager.io/docs/installation/

set -e
CERT_MANAGER_VERSION="${1:-v1.14.4}"
MANIFEST="https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml"

echo "Installing cert-manager ${CERT_MANAGER_VERSION}..."
kubectl apply -f "$MANIFEST"

echo "Waiting for cert-manager to be ready..."
kubectl wait -n cert-manager --for=condition=ready pod -l app.kubernetes.io/instance=cert-manager --timeout=120s 2>/dev/null || true

echo "Done. Create a ClusterIssuer for Let's Encrypt (see cert-manager docs) so the Ingress TLS secret is issued."
