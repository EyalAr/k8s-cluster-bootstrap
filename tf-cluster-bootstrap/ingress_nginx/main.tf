resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "controller.podAnnotations.linkerd\\.io/inject"
    value = "enabled"
  }
}
