module "cert_manager" {
  source = "./cert_manager"

  providers = {
    helm = helm
  }
}

module "linkerd" {
  source = "./linkerd"

  trust_anchor_cert = file(var.linkerd_trust_anchor_cert_path)
  trust_anchor_key  = file(var.linkerd_trust_anchor_key_path)

  providers = {
    kubernetes = kubernetes,
    helm       = helm
  }

  depends_on = [module.cert_manager]
}

module "olm" {
  source = "./olm"

  providers = {
    kubectl = kubectl
  }
}

module "ingress_nginx" {
  source = "./ingress_nginx"

  webmaster_email = var.webmaster_email

  providers = {
    helm       = helm,
    kubernetes = kubernetes,
    kubectl    = kubectl
  }

  depends_on = [module.linkerd]
}

module "kube_prometheus_stack" {
  source = "./kube_prometheus_stack"

  domains = var.domains

  providers = {
    helm       = helm,
    kubernetes = kubernetes,
    kubectl    = kubectl
  }

  depends_on = [module.olm]
}

module "linkerd_viz" {
  source = "./linkerd_viz"

  linkerd_namespace    = module.linkerd.linkerd_namespace
  monitoring_namespace = module.kube_prometheus_stack.monitoring_namespace
  grafana_url          = module.kube_prometheus_stack.grafana_url
  grafana_labels       = module.kube_prometheus_stack.grafana_labels

  providers = {
    kubernetes = kubernetes,
    helm       = helm
  }
}
