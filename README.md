# Cloud Native SRE & Infrastructure Showcase 🚀

This repository serves as a professional portfolio demonstrating **Senior Site Reliability Engineering (SRE)** and **Solutions Architecture** competencies. It implements a production-grade environment focusing on scalability, resilience, governance, and automated delivery.

---

## 🏗️ Architecture Overview

The project follows a **GitOps** and **Infrastructure as Code (IaC)** philosophy, structured as a monorepo for better visibility and consistency across different layers:

* **Infrastructure (Terraform):** Modularized setup for Kubernetes governance (Namespaces, ResourceQuotas, and NetworkPolicies).
* **Workloads (Kubernetes):** High-availability deployments using Horizontal Pod Autoscaling (HPA), Pod Disruption Budgets (PDB), and Health Probes.
* **Delivery (GitOps):** Continuous Deployment managed via ArgoCD patterns with automated drift correction.
* **Automation (CI/CD):** GitHub Actions pipeline incorporating **DevSecOps** (Security Scans) and **Validation** (Ephemeral Kind Clusters).

---

## 🛠️ Key SRE Features Implemented

### 1. Resilience & Reliability (Kubernetes)
* **Self-Healing:** Configured `liveness` and `readiness` probes to ensure traffic only hits healthy containers and deadlocked apps are automatically recovered.
* **Disruption Management:** Implemented `PodDisruptionBudget` to guarantee minimum service availability during maintenance or node upgrades.
* **Zero-Downtime:** Utilized `RollingUpdate` strategy to ensure seamless version transitions.

### 2. Governance & FinOps (Terraform)
* **Hard Resource Quotas:** Applied `ResourceQuota` at the namespace level to prevent "noisy neighbors" and ensure predictable cloud spending.
* **Environment Isolation:** Modular architecture allowing identical logic to be applied across `Dev`, `Staging`, and `Prod` with environment-specific overrides.

### 3. DevSecOps (Security-First)
* **Shift-Left Security:** Automated infrastructure scanning using **Checkov** to detect misconfigurations before they reach production.
* **Principle of Least Privilege:** Containers configured with `securityContext` to run as non-root users.

### 4. Incident Management & Observability
* **Blameless Post-Mortems:** A structured incident report ([see docs](./docs/incidents/)) detailing Root Cause Analysis (RCA) and preventative action items.
* **Observability as Code:** Dashboard definitions versioned as JSON, focusing on the **Four Golden Signals** (Latency, Traffic, Errors, and Saturation).

---

## 📁 Repository Structure

```text
├── .github/workflows/   # CI/CD: Security scans & validation
├── terraform/           # IaC: Modules and Environment setup
├── kubernetes/base/     # K8s: Deployment, Service, HPA, PDB
├── gitops/              # GitOps: ArgoCD Application manifests
└── docs/                # SRE: Incident reports & Dashboard models