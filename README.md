# portfolio-k8s-security

This repository defines Kubernetes security controls used across the
DevSecOps portfolio. The focus stays on workload hardening, network
isolation, admission enforcement, runtime detection, and operational
visibility inside the cluster.

This repository works together with CI security pipelines, daily
security automation, and the portfolio threat model to provide full
lifecycle coverage.

## Badges and Status

[![Daily Security](https://github.com/asadyare/portfolio-daily-security/actions/workflows/security-alerting-and-reporting.yml/badge.svg)](https://github.com/asadyare/portfolio-daily-security/actions/workflows/security-alerting-and-reporting.yml)

[![Runtime Security Falco](https://img.shields.io/badge/Runtime%20Security-Falco%20Enabled-brightgreen)](https://falco.org/)

## Stack

- Kubernetes
- Docker
- Node.js
- Nginx Ingress
- Trivy
- kube-bench
- kube-linter
- Prometheus
- Grafana
- GitHub Actions

[![k8s-security Architecture](diagrams/architecture.png)](diagrams/architecture.png)

## Platform Kubernetes security focused

### Purpose and Scope

This repository enforces security at deploy time and runtime.
Application code and CI logic live in other repositories.

### Scope includes

Kubernetes workload hardening Pod Security Admission enforcement Zero
trust networking Ingress control with TLS Resource quotas and abuse
protection Runtime detection with Falco Observability for security
evidence

### Repository Structure

- ci CI validation for Kubernetes manifests

- docker Hardened container build aligned with runtime policies

- k8s base Core Kubernetes resources such as Namespace, Deployment,
  Service

- security Network policies, resource quotas, admission enforcement

- ingress Ingress configuration with TLS

- observability Prometheus ServiceMonitor and Grafana dashboard
  placeholders

- runtime Falco runtime detection configuration and manifests

- Security Controls Implemented

- Admission and Workload Security

- Namespaces enforce restricted Pod Security Admission. Pods run as non
  root. Privilege escalation disabled. Capabilities dropped. Seccomp uses
  runtime default.

### Network Security

- Default deny NetworkPolicy blocks all ingress and egress. Explicit allow
  rules permit traffic only from the ingress controller. Services remain
  internal by default.

- Ingress and TLS

- Ingress exposes the service through a single controlled entry point. TLS
  terminates at the ingress layer. Direct service and pod access remains
  blocked.

### Resource Protection

- ResourceQuota caps CPU, memory, and pod counts. Blast radius stays
  limited even during compromise.

### Runtime Detection with Falco

Falco runs as a DaemonSet on every cluster node. It monitors system
calls and container behaviour at runtime.

Detected threat classes include

Container escape attempts Privilege escalation Unexpected shell
execution Writes to sensitive paths Suspicious network tooling

Falco Severity Model

Critical Container escape attempts Privilege escalation Shell spawned in
container

High Writes to system paths Unexpected outbound connections

Medium Suspicious process execution

Low Informational activity

Severity Routing

Critical Creates a security alert issue Included in daily and weekly
security reporting

High Included in weekly security report

Medium Logged for investigation

Low Ignored

Observability and Evidence

Prometheus collects workload metrics. Grafana dashboards provide
operational visibility. Falco events provide runtime evidence.
Kubernetes logs support investigation.

Threat to Control Mapping

Privilege escalation Control Pod Security Admission, non root containers
Layer Kubernetes admission

Lateral movement Control Default deny NetworkPolicy Layer Kubernetes
networking

Malicious container images Control CI scanning, hardened Dockerfile
Layer CI and build

Container escape Control Falco runtime detection Layer Runtime

Resource abuse Control ResourceQuota Layer Runtime

Plaintext traffic Control Ingress with TLS Layer Ingress

Silent failure Control Prometheus and Grafana Layer Observability

## Connected Repositories

1. [Frontend application](https://github.com/asadyare/portfolio-frontend)
2. [CI CD and security pipelines](https://github.com/asadyare/portfolio-ci-cd-security)
3. [Threat modeling and risk analysis](https://github.com/asadyare/portfolio-threat-model)
4. [Daily security automation](https://github.com/asadyare/portfolio-daily-security)

## Contact

You can contact me via [walasaqo@gmail.com](mailto:walasaqo@gmail.com) or connect with me on [LinkedIn](https://www.linkedin.com/in/asad-hassan-20b540313/).

## License

This portfolio is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
