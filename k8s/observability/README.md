# Prometheus monitoring (optional)

The `ServiceMonitor` resource requires [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator) CRDs to be installed first.

**If you use Prometheus Operator**, create this resource (e.g. save as `prometheus-servicemonitor.yaml` and apply after installing the operator):

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: portfolio
  namespace: portfolio
spec:
  selector:
    matchLabels:
      app: portfolio
  endpoints:
  - port: http
    interval: 30s
```

**Install Prometheus Operator** (e.g. via Helm):

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

Then apply the ServiceMonitor above so Prometheus scrapes the portfolio app.
