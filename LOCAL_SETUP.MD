# Local setup
## Generate Linkerd certs ([reference](https://linkerd.io/2.14/tasks/generate-certificates)):

```bash
mkdir -p .local

# Trust anchor certificate
step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure --not-after=87600h

# Issuer certificate and key
step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key
```
