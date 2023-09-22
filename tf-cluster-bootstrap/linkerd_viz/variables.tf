variable "linkerd_namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "grafana_url" {
  type = string
}

variable "grafana_labels" {
  type = map(string)
}

variable "domain" {
  type = string
}
