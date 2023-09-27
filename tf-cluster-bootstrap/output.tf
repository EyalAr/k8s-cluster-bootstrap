output "linkerd_viz_username" {
  value = "admin"
}

output "linkerd_viz_password" {
  value     = module.linkerd_viz.linkerd_viz_password
  sensitive = true
}

output "grafana_username" {
  value = "admin"
}

output "grafana_password" {
  value     = module.kube_prometheus_stack.grafana_password
  sensitive = true
}

output "longhorn_ui_username" {
  value = "admin"
}

output "longhorn_ui_password" {
  value     = module.longhorn_storage.longhorn_ui_password
  sensitive = true
}

output "postgres_password" {
  value     = module.postgres.postgres_password
  sensitive = true
}
