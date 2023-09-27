resource "kubernetes_namespace" "postgres" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
    name = "postgres"
  }
}

resource "random_password" "postgres_password" {
  length = 16
}

resource "kubernetes_secret_v1" "postgres_credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.postgres.metadata[0].name
  }
  data = {
    "postgres-password" = random_password.postgres_password.result
  }
}

resource "helm_release" "postgres" {
  name       = "postgres"
  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "postgresql"
  namespace  = kubernetes_namespace.postgres.metadata[0].name

  set {
    name  = "global.postgresql.auth.existingSecret"
    value = kubernetes_secret_v1.postgres_credentials.metadata[0].name
  }

  set {
    name  = "primary.persistence.storageClass"
    value = "longhorn"
  }
}
