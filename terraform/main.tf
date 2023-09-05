module "cert_manager" {
  source = "./cert_manager"

  providers = {
    helm = helm
  }
}

module "linkerd" {
  source            = "./linkerd"
  trust_anchor_cert = file(var.linkerd_trust_anchor_cert_path)
  trust_anchor_key  = file(var.linkerd_trust_anchor_key_path)
  domains           = var.domains

  providers = {
    kubernetes = kubernetes,
    helm       = helm
  }

  depends_on = [module.cert_manager]
}

module "ingress_nginx" {
  source          = "./ingress_nginx"
  webmaster_email = var.webmaster_email

  depends_on = [module.linkerd]

  providers = {
    helm       = helm,
    kubernetes = kubernetes,
    kubectl    = kubectl
  }
}

module "olm" {
  source = "./olm"

  providers = {
    kubectl = kubectl
  }
}

module "kube_prometheus_stack" {
  source                 = "./kube_prometheus_stack"
  domains                = var.domains
  grafana_admin_password = var.grafana_admin_password

  providers = {
    helm       = helm,
    kubernetes = kubernetes,
    kubectl    = kubectl
  }

  depends_on = [module.olm]
}
