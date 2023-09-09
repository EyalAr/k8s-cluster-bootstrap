variable "domains" {
  type = list(string)
}

variable "webmaster_email" {
  type = string
}

variable "linkerd_trust_anchor_cert_path" {
  type      = string
  sensitive = true
}

variable "linkerd_trust_anchor_key_path" {
  type      = string
  sensitive = true
}
