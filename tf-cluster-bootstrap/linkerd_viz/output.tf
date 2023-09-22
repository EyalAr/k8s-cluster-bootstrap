output "linkerd_viz_password" {
  value     = random_password.linkerd_viz_password.result
  sensitive = true
}
