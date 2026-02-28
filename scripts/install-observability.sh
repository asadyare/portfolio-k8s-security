#!/usr/bin/env bash
# Install Prometheus + Grafana (kube-prometheus-stack) and portfolio dashboard
# Requires: helm, kubectl

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing kube-prometheus-stack (Prometheus + Grafana)..."

command -v helm >/dev/null || { echo "helm is required. Install from https://helm.sh"; exit 1; }

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  --set grafana.sidecar.dashboards.enabled=true

echo ""
echo "Waiting for pods to be ready..."
kubectl wait -n monitoring --for=condition=ready pod -l app.kubernetes.io/name=grafana --timeout=120s 2>/dev/null || true
kubectl wait -n monitoring --for=condition=ready pod -l app.kubernetes.io/name=prometheus --timeout=120s 2>/dev/null || true

echo ""
echo "Applying portfolio Grafana dashboard ConfigMap..."
kubectl apply -f "$SCRIPT_DIR/../k8s/observability/grafana-dashboard-configmap.yaml"

echo ""
echo "Done. Access Grafana:"
echo "  kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80"
echo "  Open http://localhost:3000  (admin / prom-operator)"
echo ""
echo "See docs/OBSERVABILITY.md for full guide."
