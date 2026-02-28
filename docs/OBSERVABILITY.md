# Observing the Portfolio Web App with Prometheus and Grafana

This guide explains how to observe the portfolio application using Prometheus (metrics) and Grafana (dashboards).

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────┐
│  Portfolio App  │     │  Ingress-Nginx   │     │  Prometheus │
│  (nginx static) │────▶│  (request logs)  │◀────│  (scrapes)  │
└─────────────────┘     └──────────────────┘     └──────┬──────┘
                                                         │
                                                         ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────┐
│  Grafana Faro   │────▶│  Grafana Cloud /  │     │   Grafana   │
│  (frontend RUM) │     │  Grafana Backend  │     │ (dashboards)│
└─────────────────┘     └──────────────────┘     └─────────────┘
```

- **Prometheus** scrapes metrics from the Ingress controller (request rate, latency, status codes) and from the cluster.
- **Grafana** visualizes those metrics in dashboards.
- **Grafana Faro** (optional) sends frontend telemetry (errors, performance) from the browser to Grafana.

---

## Step 1: Install Prometheus and Grafana (kube-prometheus-stack)

Install the stack once per cluster:

```powershell
.\scripts\install-observability.ps1
```

```bash
./scripts/install-observability.sh
```

Or manually:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

Wait for pods to be ready:

```bash
kubectl get pods -n monitoring
```

---

## Step 2: Metrics Source

The portfolio app (nginx) does not expose Prometheus metrics directly. Metrics come from **ingress-nginx**, which the kube-prometheus-stack scrapes by default. You get:

- Request rate, latency, and status codes for traffic to the portfolio Ingress
- No extra ServiceMonitor needed

If you add a `/metrics` endpoint to the app later, you can add a ServiceMonitor (see `k8s/observability/README.md`).

---

## Step 3: Access Grafana

**Port-forward to Grafana:**

```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

Open http://localhost:3000. Default credentials:
- **Username:** `admin`
- **Password:** `prom-operator` (or check the secret: `kubectl get secret -n monitoring prometheus-grafana -o jsonpath='{.data.admin-password}' | base64 -d`)

**Change the password** when prompted.

---

## Step 4: View the Portfolio Dashboard

1. In Grafana, go to **Dashboards** → **Browse**.
2. Open **Portfolio Application Overview** (provisioned from the ConfigMap).

If the dashboard is not visible, import it manually:

1. **Dashboards** → **New** → **Import**.
2. Upload or paste the JSON from `k8s/observability/grafana-dashboard-configmap.yaml` (the `portfolio-dashboard.json` value).
3. Select **Prometheus** as the data source.

**Note:** The dashboard uses `ingress=~"portfolio.*"` and `namespace="portfolio"`. If your Ingress name or namespace differs, edit the panel queries.

---

## Step 5 (Optional): Grafana Faro for Frontend RUM

Grafana Faro sends real-user monitoring (errors, performance, traces) from the browser. The portfolio app has `@grafana/faro-web-sdk` and `@grafana/faro-web-tracing` as dependencies.

**Option A: Grafana Cloud (easiest)**

1. Sign up at [grafana.com/products/cloud](https://grafana.com/products/cloud).
2. Create an application and get the Faro collector URL.
3. In `portfolio-frontend/src/main.jsx`, add:

```javascript
import { getWebInstrumentations, initializeFaro } from '@grafana/faro-web-sdk';
import { getWebTracingInstrumentation } from '@grafana/faro-web-tracing';

initializeFaro({
  url: 'https://faro-collector-prod-us-central-0.grafana.net/collect/your-app-id',
  app: { name: 'portfolio', version: '1.0.0' },
  instrumentations: [
    ...getWebInstrumentations(),
    getWebTracingInstrumentation(),
  ],
});
```

**Option B: Self-hosted Grafana with Faro**

Deploy the [Grafana Faro collector](https://grafana.com/docs/faro/latest/setup/) in your cluster and point the SDK to it.

---

## Useful Prometheus Queries

In Grafana → Explore → Prometheus:

| Query | Description |
|-------|-------------|
| `rate(nginx_ingress_controller_requests{ingress="portfolio"}[5m])` | Request rate to portfolio |
| `nginx_ingress_controller_request_duration_seconds_bucket{ingress="portfolio"}` | Request latency histogram |
| `sum(rate(nginx_ingress_controller_requests{ingress="portfolio"}[5m])) by (status)` | Status code distribution |

---

## Troubleshooting

- **No data in Grafana:** Ensure Prometheus is scraping. Check **Status** → **Targets** in Prometheus.
- **Ingress metrics missing:** The Ingress controller must expose `/metrics`. Verify with `kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 10254:10254` and `curl localhost:10254/metrics`.
- **Dashboard not loading:** Ensure the ConfigMap has label `grafana_dashboard: "1"` and is in the `monitoring` namespace.
