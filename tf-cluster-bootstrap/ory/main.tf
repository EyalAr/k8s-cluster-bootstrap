resource "kubernetes_namespace" "ory" {
  count = 0
  metadata {
    name = "ory"
  }
}