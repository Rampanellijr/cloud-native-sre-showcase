# Cloud Native SRE Showcase 🚀

> **Production-Grade Infrastructure, Automation, and Observability Patterns.**

This repository serves as a practical demonstration of Senior SRE & Solutions Architect capabilities. It implements a complete **GitOps-driven** workflow, **Infrastructure as Code (IaC)** governance, and **Reliability Engineering** principles (SRE) without relying on paid cloud resources for demonstration.

---

## 📚 Technical Competencies (Interview Questions Map)

### 1. Kubernetes Resilience & Health
* **Question:** How do you configure readiness and liveness probes?
* **Answer:** See [`kubernetes/base/deployment.yaml`](./kubernetes/base/deployment.yaml).
    * Implemented **Liveness Probes** to restart deadlocked containers.
    * Implemented **Readiness Probes** to ensure zero-downtime deployments.

### 2. Disruption Management (PDB)
* **Question:** What is a PodDisruptionBudget?
* **Answer:** See [`kubernetes/base/deployment.yaml`](./kubernetes/base/deployment.yaml) (Line 75).
    * Configured `minAvailable: 1` to ensure high availability during node drains or upgrades.

### 3. Autoscaling (HPA) & FinOps
* **Question:** How do you implement autoscaling?
* **Answer:** See [`kubernetes/base/deployment.yaml`](./kubernetes/base/deployment.yaml) (Line 85).
    * **HPA** configured on CPU utilization (75%) to handle traffic spikes efficiently.
    * **Resource Limits** set to prevent "noisy neighbor" issues and control costs.

### 4. Terraform Governance & State
* **Question:** How do you structure Terraform and handle state?
* **Answer:** See [`terraform/modules`](./terraform/modules) and [`terraform/environments/prod`](./terraform/environments/prod).
    * **Modular Architecture:** Reusable modules enforce standard tagging and quotas.
    * **State Isolation:** Environment separation (Dev/Prod) with (mocked) S3 Backend + DynamoDB Locking.

### 5. GitOps & Drift Management
* **Question:** How do you handle configuration drift?
* **Answer:** See [`gitops/application.yaml`](./gitops/application.yaml).
    * Uses **ArgoCD** with `selfHeal: true`. Any manual change (`kubectl edit`) is immediately overwritten by the state defined in Git.

### 6. Incident Management
* **Question:** Walk through a production incident you resolved.
* **Answer:** See [`docs/incidents/2025-11-14-postgres-connection-pool.md`](./docs/incidents/).
    * A structured **Post-Mortem** analyzing a Root Cause (Connection Exhaustion) and defining preventative Action Items.

### 7. Observability as Code
* **Question:** How do you design dashboards?
* **Answer:** See [`docs/observability/dashboard-model.json`](./docs/observability/dashboard-model.json).
    * Dashboards are versioned as JSON code, focusing on **Golden Signals** (Latency, Traffic, Errors, Saturation).

### 8. Security (DevSecOps)
* **Question:** How do you enforce least privilege and security scanning?
* **Answer:** See [`.github/workflows/deploy.yml`](./.github/workflows/deploy.yml).
    * **Shift-Left Security:** Automated **Checkov** scans in the CI pipeline block insecure Terraform code before it reaches production.
    * **Context:** Kubernetes SecurityContext (`runAsNonRoot: true`) applied in deployment manifests.

---

## 🛠️ How to Validate (Zero Cost)

Prerequisites: `docker`, `kind`, `terraform`.

1. **Spin up a local cluster:**
   ```bash
   kind create cluster --name sre-showcase