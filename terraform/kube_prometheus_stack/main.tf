variable "domains" {
  type = list(string)
}

variable "grafana_admin_password" {
  type = string
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }

    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name = "kube-prometheus-stack"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = false

  values = [templatefile("${path.module}/values.yaml", { domains = var.domains, grafana_admin_password = var.grafana_admin_password })]

  depends_on = [kubernetes_namespace.monitoring]
}

resource "helm_release" "grafana_operator" {
  name       = "grafana-operator"
  repository = "oci://ghcr.io/grafana-operator/helm-charts"
  chart      = "grafana-operator"
  version    = "v5.4.0"
  namespace  = "monitoring"
}

resource "kubernetes_secret_v1" "grafana_creds" {
  metadata {
    name      = "grafana-admin-credentials"
    namespace = "monitoring"
  }
  data = {
    GF_SECURITY_ADMIN_USER     = "admin"
    GF_SECURITY_ADMIN_PASSWORD = var.grafana_admin_password
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "grafana" {
  depends_on = [helm_release.grafana_operator, kubernetes_secret_v1.grafana_creds]

  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "Grafana"
    metadata = {
      namespace = "monitoring"
      name      = "grafana"
      labels = {
        dashboards = "grafana"
      }
    }
    spec = {
      external = {
        url = "http://kube-prometheus-stack-grafana"
        adminPassword = {
          name = "grafana-admin-credentials"
          key  = "GF_SECURITY_ADMIN_PASSWORD"
        }
        adminUser = {
          name = "grafana-admin-credentials"
          key  = "GF_SECURITY_ADMIN_USER"
        }
      }
    }
  }
}
