resource "helm_release" "linkerd_viz" {
  name = "linkerd-viz"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-viz"

  namespace = var.linkerd_namespace

  values = [templatefile("${path.module}/viz.values.yaml", {
    grafana_url = var.grafana_url
  })]
}

resource "random_password" "linkerd_viz_password" {
  length  = 32
}

resource "random_password" "linkerd_viz_password_salt" {
  length = 8
}

resource "htpasswd_password" "linkerd_viz_password_hash" {
  password = random_password.linkerd_viz_password.result
  salt     = random_password.linkerd_viz_password_salt.result
}

resource "kubernetes_secret_v1" "linkerd_viz_auth" {
  metadata {
    name      = "linkerd-viz-auth"
    namespace = var.linkerd_namespace
  }

  data = {
    auth = "admin:${htpasswd_password.linkerd_viz_password_hash.bcrypt}"
  }

  type = "Opaque"
}

resource "kubernetes_ingress_v1" "linkerd_viz_web" {
  metadata {
    name      = "linkerd-viz-web"
    namespace = var.linkerd_namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                    = "letsencrypt"
      "nginx.ingress.kubernetes.io/auth-type"             = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"           = "linkerd-viz-auth"
      "nginx.ingress.kubernetes.io/auth-realm"            = "Authentication Required - admin"
      "nginx.ingress.kubernetes.io/service-upstream"      = "true"
      "nginx.ingress.kubernetes.io/upstream-vhost"        = "web.linkerd.svc.cluster.local:8084"
      "nginx.ingress.kubernetes.io/use-regex"             = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"        = "/$2"
      "nginx.ingress.kubernetes.io/configuration-snippet" = <<EOF
        sub_filter_once off;
        sub_filter '<head>' '<head> <base href="linkerd/">';
        sub_filter 'src="/' 'src="/linkerd/';
        sub_filter 'href="/' 'href="/linkerd/';
        sub_filter '/\/api\/v1\/namespaces\/.*\/proxy/g' '/\/linkerd/g';
        sub_filter_types text/html text/css text/javascript;
        proxy_set_header Origin "";
      EOF
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
          path      = "/linkerd(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "web"
              port {
                number = 8084
              }
            }
          }
        }
      }
    }
  }
}

# the following are commented out because the prometheus operator doesn't support ScrapeConfig with role=Pod
# instead, we define them in the prometheus operator's values.yaml

# resource "kubernetes_manifest" "linkerd_viz_prometheus_scrape_config_linkerd_controller" {
#   manifest = {
#     apiVersion = "monitoring.coreos.com/v1alpha1"
#     kind       = "ScrapeConfig"
#     metadata = {
#       name      = "linkerd-controller"
#       namespace = "linkerd"
#     }
#     spec = {
#       kubernetesSDConfigs = [
#         {
#           role = "Pod"
#           namespaces = {
#             names = ["linkerd"]
#           }
#         }
#       ]
#       relabelings = [
#         {
#           sourceLabels = ["__meta_kubernetes_pod_container_port_name"]
#           action       = "keep"
#           regex        = "admin-http"
#         },
#         {
#           sourceLabels = ["__meta_kubernetes_pod_container_name"]
#           action       = "replace"
#           targetLabel  = "component"
#         }
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "linkerd_viz_prometheus_scrape_config_linkerd_service_mirror" {
#   manifest = {
#     apiVersion = "monitoring.coreos.com/v1alpha1"
#     kind       = "ScrapeConfig"
#     metadata = {
#       name      = "linkerd-service-mirror"
#       namespace = "linkerd"
#     }
#     spec = {
#       kubernetesSDConfigs = [
#         {
#           role = "Pod"
#         }
#       ]
#       relabelings = [
#         {
#           sourceLabels = ["__meta_kubernetes_pod_label_linkerd_io_control_plane_component", "__meta_kubernetes_pod_container_port_name"]
#           action       = "keep"
#           regex        = "linkerd-service-mirror;admin-http$"
#         },
#         {
#           sourceLabels = ["__meta_kubernetes_pod_container_name"]
#           action       = "replace"
#           targetLabel  = "component"
#         }
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "linkerd_viz_prometheus_scrape_config_linkerd_proxy" {
#   manifest = {
#     apiVersion = "monitoring.coreos.com/v1alpha1"
#     kind       = "ScrapeConfig"
#     metadata = {
#       name      = "linkerd-proxy"
#       namespace = "linkerd"
#     }
#     spec = {
#       kubernetesSDConfigs = [
#         {
#           role = "Pod"
#         }
#       ]
#       relabelings = [
#         {
#           sourceLabels = ["__meta_kubernetes_pod_container_name", "__meta_kubernetes_pod_container_port_name", "__meta_kubernetes_pod_label_linkerd_io_control_plane_ns"]
#           action       = "keep"
#           regex        = "^linkerd-proxy;linkerd-admin;linkerd$"
#         },
#         {
#           sourceLabels = ["__meta_kubernetes_namespace"]
#           action       = "replace"
#           targetLabel  = "namespace"
#         },
#         {
#           sourceLabels = ["__meta_kubernetes_pod_name"]
#           action       = "replace"
#           targetLabel  = "pod"
#         },
#         {
#           sourceLabels = ["__meta_kubernetes_pod_label_linkerd_io_proxy_job"]
#           action       = "replace"
#           targetLabel  = "k8s_job"
#         },
#         {
#           action = "labeldrop"
#           regex  = "__meta_kubernetes_pod_label_linkerd_io_proxy_job"
#         },
#         {
#           action = "labelmap"
#           regex  = "__meta_kubernetes_pod_label_linkerd_io_proxy_(.+)"
#         },
#         {
#           action = "labeldrop"
#           regex  = "__meta_kubernetes_pod_label_linkerd_io_proxy_(.+)"
#         },
#         {
#           action = "labelmap"
#           regex  = "__meta_kubernetes_pod_label_linkerd_io_(.+)"
#         },
#         {
#           action      = "labelmap"
#           regex       = "__meta_kubernetes_pod_label_(.+)"
#           replacement = "__tmp_pod_label_$1"
#         },
#         {
#           action      = "labelmap"
#           regex       = "__tmp_pod_label_linkerd_io_(.+)"
#           replacement = "__tmp_pod_label_$1"
#         },
#         {
#           action = "labeldrop"
#           regex  = "__tmp_pod_label_linkerd_io_(.+)"
#         },
#         {
#           action = "labelmap"
#           regex  = "__tmp_pod_label_(.+)"
#         }
#       ]
#     }
#   }
# }
