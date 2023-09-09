resource "helm_release" "linkerd_viz" {
  name = "linkerd-viz"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-viz"

  namespace = var.linkerd_namespace

  values = [templatefile("${path.module}/viz.values.yaml", {
    grafana_url = var.grafana_url
  })]
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
