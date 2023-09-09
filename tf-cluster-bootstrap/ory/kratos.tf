resource "helm_release" "ory_kratos" {
    count = 0
    name = "ory-kratos"

    repository = "https://k8s.ory.sh/helm/charts"
    chart = "ory-kratos"

    namespace = kubernetes_namespace.ory.metadata[0].name
    create_namespace = false

    depends_on = [ kubernetes_namespace.ory ]
}