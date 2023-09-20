variable "tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "config_file_profile" {
  type = string
}

variable "parent_compartment_ocid" {
  type      = string
  sensitive = true
}

variable "compartment_name" {
  type = string
}

variable "compartment_description" {
  type = string
}

variable "domain" {
  type = string
}
