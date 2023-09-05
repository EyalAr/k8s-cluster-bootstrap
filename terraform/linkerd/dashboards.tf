resource "kubernetes_manifest" "grafana_linkerd_dashboard" {
  for_each = toset(["15474", "15486", "15479", "15478", "15475", "15477", "15480", "15481", "15482", "15483", "15487", "15484", "15491", "15493", "15492", "15489", "15490", "15488"])
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDashboard"
    metadata = {
      namespace = "monitoring"
      name      = "linkerd-${each.value}"
    }
    spec = {
      instanceSelector = {
        matchLabels = {
          dashboards = "grafana"
        }
      }
      grafanaCom = {
        id = each.value
      }
      datasources = [
        {
          inputName      = "DS_PROMETHEUS"
          datasourceName = "Prometheus"
        }
      ]
    }
  }
}
