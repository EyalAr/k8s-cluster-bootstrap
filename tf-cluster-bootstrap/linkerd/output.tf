output "linkerd_namespace" {
  value = kubernetes_namespace.linkerd.metadata[0].name
}
