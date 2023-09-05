variable "domains" {
  type = list(string)
}

variable "webmaster_email" {
  type = string
}

variable "linkerd_trust_anchor_cert_path" {
  type = string
}

variable "linkerd_trust_anchor_key_path" {
  type = string
}

variable "grafana_admin_password" {
  sensitive = true
  type = string
}
