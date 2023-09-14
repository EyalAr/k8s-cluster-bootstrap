resource "oci_identity_compartment" "compartment" {
  compartment_id = var.parent_compartment_ocid
  name           = var.compartment_name
  description    = var.compartment_description
}
