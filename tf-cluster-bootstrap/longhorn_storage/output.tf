output "longhorn_ui_password" {
  value     = random_password.longhorn_ui_password.result
  sensitive = true
}
