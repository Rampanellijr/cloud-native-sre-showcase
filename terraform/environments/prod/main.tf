terraform {
  required_version = ">= 1.0.0"

  # ---------------------------------------------------------
  # State Management (Question 4: Handling State)
  # Production Best Practice: Remote State with Locking
  # ---------------------------------------------------------
  # Note: Commented out for local demonstration purposes. 
  # In a real scenario, this block is mandatory to prevent state corruption.
  
  # backend "s3" {
  #   bucket         = "terraform-state-prod-12345"
  #   key            = "k8s/production/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-lock-table" # Prevents concurrent modifications
  # }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

# Provider Configuration
# connecting to the cluster (EKS, GKE, or local Kind/Minikube)
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-sre-showcase" # Adjust context based on your cluster
}

# ---------------------------------------------------------
# Module Instantiation: Production Environment
# ---------------------------------------------------------
module "production_namespace" {
  source = "../../modules/k8s-base"

  # Inputs defined in variables.tf
  namespace_name = "app-production"
  environment    = "production"

  # FinOps Strategy:
  # Allocating more resources for Production compared to Dev/Staging
  cpu_limit      = "4"    # 4 vCPUs quota
  memory_limit   = "8Gi"  # 8GB RAM quota
}

# Output useful information for CI/CD pipelines
output "prod_namespace_id" {
  value = module.production_namespace.namespace_id
}