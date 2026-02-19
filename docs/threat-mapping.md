# Threat to Control Mapping

| Threat                     | Control                                     | Layer                 | Evidence                               |
| -------------------------- | ------------------------------------------- | --------------------- | -------------------------------------- |
| Privilege escalation       | Pod Security Admission, non root containers | Kubernetes admission  | Namespace labels, deployment manifests |
| Lateral movement           | Default deny NetworkPolicy                  | Kubernetes networking | NetworkPolicy manifests                |
| Malicious container images | CI scanning, hardened Dockerfile            | CI and build          | CI logs, Dockerfile                    |
| Container escape           | Falco runtime detection                     | Runtime               | Falco events                           |
| Resource abuse             | ResourceQuota limits                        | Kubernetes runtime    | ResourceQuota manifest                 |
| Plaintext traffic          | Ingress with TLS                            | Ingress               | Ingress manifest, TLS secret           |
| Silent failure             | Prometheus and Grafana                      | Observability         | Metrics and dashboards                 |
