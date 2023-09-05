variable "webmaster_email" {
  type = string
}

resource "kubernetes_manifest" "letsencrypt_cluster_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "email"  = "${var.webmaster_email}"
        "privateKeySecretRef" = {
          "name" = "letsencrypt"
        }
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "ingressClassName" = "nginx"
              }
            }
          }
        ]
      }
    }
  }
}
