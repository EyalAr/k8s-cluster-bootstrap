resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = "linkerd"
  }
}

resource "kubernetes_secret" "linkerd_trust_anchor" {
  metadata {
    name      = "linkerd-trust-anchor"
    namespace = kubernetes_namespace.linkerd.metadata[0].name
  }

  data = {
    "tls.crt" = var.trust_anchor_cert
    "tls.key" = var.trust_anchor_key
  }
}

resource "kubernetes_manifest" "linkerd_trust_anchor" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = "linkerd-trust-anchor"
      namespace = kubernetes_namespace.linkerd.metadata[0].name
    }
    spec = {
      ca = {
        secretName = "linkerd-trust-anchor"
      }
    }
  }

  depends_on = [kubernetes_secret.linkerd_trust_anchor]
}

resource "kubernetes_manifest" "linkerd_identity_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "linkerd-identity-issuer"
      namespace = kubernetes_namespace.linkerd.metadata[0].name
    }
    spec = {
      secretName  = "linkerd-identity-issuer"
      duration    = "48h0m0s"
      renewBefore = "25h0m0s"
      issuerRef = {
        name = "linkerd-trust-anchor"
        kind = "Issuer"
      }
      commonName = "identity.linkerd.cluster.local"
      dnsNames   = ["identity.linkerd.cluster.local"]
      isCA       = true
      privateKey = {
        algorithm = "ECDSA"
      }
      usages = ["cert sign", "crl sign", "server auth", "client auth"]
    }
  }

  depends_on = [kubernetes_manifest.linkerd_trust_anchor]
}

resource "helm_release" "linkerd_crds" {
  name = "linkerd-crds"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-crds"

  namespace = kubernetes_namespace.linkerd.metadata[0].name
}

resource "helm_release" "linkerd_control_plane" {
  name = "linkerd-control-plane"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-control-plane"

  namespace = kubernetes_namespace.linkerd.metadata[0].name

  set {
    name  = "identityTrustAnchorsPEM"
    value = var.trust_anchor_cert
  }

  set {
    name  = "identity.issuer.scheme"
    value = "kubernetes.io/tls"
  }
}
