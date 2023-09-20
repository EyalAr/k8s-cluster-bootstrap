# K8S Cluster Bootstrap

This repository contains Terraform projects which help setting up and bootstrapping a new K8S cluster with a service mesh, API gateway, monitoring, etc.

## Projects

### [Cluster Bootstrap](./tf-cluster-bootstrap/)

Start here if you already have an empty K8S cluster and a SQL database. Otherwise see below.

This will install the following on any empty K8S cluster:

- Cert-Manager
- Linkerd service mesh
- Operator Lifecycle Manager
- Nginx ingress
- Prometheus & Grafana
- Ory stack for authentication, authorization and user management

### [Oracle Cloud Infrastructure and a K3S cluster setup (optional)](./tf-oci-k3s-cluster/)

Oracle Cloud offers always-free resources (e.g. compute instances, load balancers, etc.) on which it's possible to run a 4-node cluster with 4 CPUs and 24Gb memory.

This will provision these resources, including a SQL database, and install a K3S cluster.

See project directory for instructions.
