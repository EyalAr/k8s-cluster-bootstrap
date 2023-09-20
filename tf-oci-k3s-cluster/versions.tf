terraform {
  required_version = ">= 1.5.6"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    oci = {
      source  = "oracle/oci"
      version = "5.12.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }
  }
}
