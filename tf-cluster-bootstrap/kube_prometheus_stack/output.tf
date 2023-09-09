output "monitoring_namespace" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_url" {
  value = "https://monitoring.${var.domains[0]}"
}

output "grafana_labels" {
  value = local.grafana_labels
}
