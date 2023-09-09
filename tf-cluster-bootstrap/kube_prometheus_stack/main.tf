resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }

    name = "monitoring"
  }
}

resource "random_password" "grafana_admin_password" {
  length  = 16
  special = true
}

resource "helm_release" "prometheus" {
  name = "kube-prometheus-stack"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  values = [templatefile("${path.module}/values.yaml", { domains = var.domains, grafana_admin_password = random_password.grafana_admin_password.result })]
}

resource "helm_release" "grafana_operator" {
  name = "grafana-operator"

  repository = "oci://ghcr.io/grafana-operator/helm-charts"
  chart      = "grafana-operator"
  version    = "v5.4.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
}

resource "kubernetes_secret_v1" "grafana_creds" {
  metadata {
    name      = "grafana-admin-credentials"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    GF_SECURITY_ADMIN_USER     = "admin"
    GF_SECURITY_ADMIN_PASSWORD = random_password.grafana_admin_password.result
  }

  type = "Opaque"
}

resource "kubernetes_manifest" "grafana" {
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "Grafana"
    metadata = {
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      name      = "grafana"
      labels    = local.grafana_labels
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

  depends_on = [helm_release.grafana_operator, kubernetes_secret_v1.grafana_creds]
}
