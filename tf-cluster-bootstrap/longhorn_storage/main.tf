resource "kubernetes_namespace" "longhorn_system" {
  metadata {
    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  depends_on = [kubernetes_namespace.longhorn_system]
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.5.1"
  namespace = "longhorn-system"
}


resource "random_password" "longhorn_ui_password" {
  length = 32
}

resource "random_password" "longhorn_ui_password_salt" {
  length = 8
}

resource "htpasswd_password" "longhorn_ui_password_hash" {
  password = random_password.longhorn_ui_password.result
  salt     = random_password.longhorn_ui_password_salt.result
}

resource "kubernetes_secret_v1" "longhorn_ui_auth" {
  depends_on = [kubernetes_namespace.longhorn_system]

  metadata {
    name      = "longhorn-ui-auth"
    namespace = "longhorn-system"
  }

  data = {
    auth = "admin:${htpasswd_password.longhorn_ui_password_hash.bcrypt}"
  }

  type = "Opaque"
}

resource "kubernetes_ingress_v1" "longhorn_ui" {
  depends_on = [kubernetes_namespace.longhorn_system]
  metadata {
    name      = "longhorn-ui"
    namespace = "longhorn-system"
    annotations = {
      "cert-manager.io/cluster-issuer"              = "letsencrypt"
      "nginx.ingress.kubernetes.io/auth-type"       = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"     = "longhorn-ui-auth"
      "nginx.ingress.kubernetes.io/auth-realm"      = "Authentication Required - admin"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10000m"
      "nginx.ingress.kubernetes.io/rewrite-target"  = "/$2"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        "monitoring.${var.domain}"
      ]
      secret_name = "monitoring-tls"
    }
    rule {
      host = "monitoring.${var.domain}"
      http {
        path {
          path      = "/longhorn(/|$)(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = "longhorn-frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
