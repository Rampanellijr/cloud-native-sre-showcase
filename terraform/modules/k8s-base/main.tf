terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# 1. Namespace Isolation
resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace_name
    
    labels = {
      environment = var.environment
      managed-by  = "terraform"
      cost-center = "engineering" # FinOps tagging
    }
  }
}

# 2. Governance & FinOps: Hard Limits
# Prevents a single namespace from consuming all cluster resources
resource "kubernetes_resource_quota" "ns_quota" {
  metadata {
    name      = "${var.namespace_name}-quota"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = var.cpu_limit
      "requests.memory" = var.memory_limit
      "limits.cpu"      = var.cpu_limit
      "limits.memory"   = var.memory_limit
      "pods"            = "20" # Limits the number of pods
    }
  }
}

# 3. Security: Default Deny Network Policy (Optional but highly recommended for Seniors)
# Ensures strictly regulated traffic flow between namespaces
resource "kubernetes_network_policy" "default_deny" {
  metadata {
    name      = "default-deny-all"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}