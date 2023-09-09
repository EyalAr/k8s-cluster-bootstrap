# K8S Cluster Bootstrap

This repository contains Terraform projects which help setting up and bootstrapping a new K8S cluster with a service mesh, API gateway, monitoring, etc.

## Projects

### [Cluster Bootstrap](./tf-cluster-bootstrap/)

Start here if you already have an empty K8S cluster and a SQL database. Otherwise, see projects below.

This will install the following on any empty K8S cluster:

- Cert-Manager
- Linkerd service mesh
- Operator Lifecycle Manager
- Nginx ingress
- Prometheus & Grafana
- Ory stack for authentication, authorization and user management

### [Oracle Cloud Infrastructure (optional)](./tf-oci-resources/)

Oracle Cloud offers always-free resources (e.g. compute instances, load balancers, etc.) on which it's possible to run a 4-node cluster with 4 CPUs and 24Gb memory.

This will provision these resources (but not the K8S cluster itself).

Once the infrastructure is set up, see below how to deploy a K3S cluster on it.

### [K3S Cluster on Oracle Cloud Infrastructure (optional)](./tf-oci-k3s-cluster/)

K3S makes it easy to deploy and run a K8S cluster.

Use this project to deploy a cluster on your Oracle Cloud infrastructure which you set up with the project above.

### Persistance

The Cluster Bootstrap requires a database. Use this project to provision one on Oracle Cloud (always-free tier).