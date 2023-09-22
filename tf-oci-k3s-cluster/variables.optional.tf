variable "vcn_display_name" {
  type    = string
  default = "vcn"
}

variable "vcn_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block_private" {
  type    = string
  default = "10.0.0.0/24"
}

variable "subnet_cidr_block_public" {
  type    = string
  default = "10.0.1.0/24"
}

variable "region_id" {
  type    = string
  default = "uk-london-1"
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
  default = "ocid1.image.oc1.uk-london-1.aaaaaaaahk5z5fbnj4mg3rq2omqsth6oewcaabb3h7uojwc4zmsfyqbqedhq" # Canonical-Ubuntu-20.04-aarch64-2023.08.27-0
}

variable "node_instance_ssh_public_key_path" {
    type    = string
    default = "~/.ssh/id_ed25519.pub"
}