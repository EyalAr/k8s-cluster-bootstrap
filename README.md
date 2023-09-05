# Empty K8S Cluster

This project sets up a new K8S cluster using Terraform, which includes:

- Cert-Manager
    - Public ingress certificates using LetsEncrypt
    - mTLS and key rotation for Linkerd
- Linkerd service mesh
    - Linkerd Viz extension
- Operator Lifecycle Manager
- Nginx ingress
- Prometheus & Grafana
- Authentication and Authorization (TBD)

Make sure you have `kubectl`, `terraform` and [`step`](https://smallstep.com/docs/step-cli/reference/) installed, e.g. with:

```bash
brew tap hashicorp/tap && brew install kubectl hashicorp/tap/terraform step
```

`kubectl` should be configured with the context of your cluster.
 
Start by creating trust anchor for Linkerd ([reference](https://linkerd.io/2.14/tasks/generate-certificates)):

```bash
step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure --not-after=87600h
```

Terraform expects variables (see `terraform/variables.tf`), which you can set in a `tfvars` file, e.g.:

```bash
cat <<EOT >> terraform/terraform.tfvars
domains                        = ["example.dev", "example.com"]
webmaster_email                = "webmaster@example.dev"
linkerd_trust_anchor_cert_path = "./ca.crt"
linkerd_trust_anchor_key_path  = "./ca.key"
grafana_admin_password         = "change_me"
EOT
```

Finally, run `terraform apply`:

```bash
cd terraform && terraform apply --var-file=terraform.tfvars
```
