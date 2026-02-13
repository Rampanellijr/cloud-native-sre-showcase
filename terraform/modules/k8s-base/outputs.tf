output "namespace_id" {
  description = "The ID of the created namespace"
  value       = kubernetes_namespace.ns.id
}

output "namespace_name" {
  description = "The name of the created namespace"
  value       = kubernetes_namespace.ns.metadata[0].name
}