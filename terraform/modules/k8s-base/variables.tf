variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "namespace_name" {
  description = "The name of the Kubernetes namespace to create"
  type        = string
}

variable "cpu_limit" {
  description = "Hard limit for CPU usage in this namespace (FinOps)"
  type        = string
  default     = "2"
}

variable "memory_limit" {
  description = "Hard limit for Memory usage in this namespace (FinOps)"
  type        = string
  default     = "4Gi"
}