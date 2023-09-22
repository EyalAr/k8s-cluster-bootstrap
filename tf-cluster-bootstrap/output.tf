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
