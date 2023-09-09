data "http" "crds_raw" {
  url = "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/crds.yaml"
}

data "http" "olm_raw" {
  url = "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/olm.yaml"
}

data "kubectl_file_documents" "crds_doc" {
  content = data.http.crds_raw.response_body
}

data "kubectl_file_documents" "olm_doc" {
  content = data.http.olm_raw.response_body
}

resource "kubectl_manifest" "crds" {
  for_each          = data.kubectl_file_documents.crds_doc.manifests
  yaml_body         = each.value
  server_side_apply = true
  wait              = true
  wait_for_rollout  = true
  force_conflicts   = true
}

resource "kubectl_manifest" "olm" {
  for_each          = data.kubectl_file_documents.olm_doc.manifests
  yaml_body         = each.value
  server_side_apply = true
  wait              = true
  wait_for_rollout  = true
  force_conflicts   = true
}
