variable "vcn_display_name" {
  type    = string
  default = "vcn"
}

variable "vcn_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "server_count" {
  type    = number
  default = 2
}

variable "agent_count" {
  type    = number
  default = 2
}

variable "subnet_cidr_block_private" {
  type    = string
  default = "10.0.0.0/24"
}

variable "subnet_cidr_block_public" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_domain" {
  type    = string
  default = "haON:UK-LONDON-1-AD-1"
}

variable "node_compute_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "node_memory_gb" {
  type    = number
  default = 6
}

variable "node_cpus" {
  type    = number
  default = 1
}

variable "node_image_id" {
  type = string
  default = "ocid1.image.oc1.uk-london-1.aaaaaaaapqvy5cln3muczrzgic2uwcy4u7bgu6hlhmx5pd363gyvesptm63a" # Canonical Ubuntu 22.04 Minimal aarch64
}

variable "node_instance_ssh_public_key_path" {
    type    = string
    default = "~/.ssh/id_ed25519.pub"
}