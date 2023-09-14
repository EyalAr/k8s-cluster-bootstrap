# Virtual Cloud Network
# This is where all the resources will be created for the cluster -
# e.g. nodes, load balancers, etc.
resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = var.vcn_display_name
}

# This will provide the VCN with internet access (both inbound and outbound)
resource "oci_core_internet_gateway" "ig" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = "true"
}

# Route all outbound traffic from the VCN through the internet gateway
resource "oci_core_route_table" "route_table" {
  vcn_id         = oci_core_vcn.vcn.id
  compartment_id = oci_identity_compartment.compartment.id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

# We allocate IP addresses compute instances from this subnet
resource "oci_core_subnet" "subnet_private" {
  cidr_block                 = var.subnet_cidr_block_private
  vcn_id                     = oci_core_vcn.vcn.id
  compartment_id             = oci_identity_compartment.compartment.id
  route_table_id             = oci_core_route_table.route_table.id
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
}

resource "oci_core_subnet" "subnet_public" {
  cidr_block                 = var.subnet_cidr_block_public
  vcn_id                     = oci_core_vcn.vcn.id
  compartment_id             = oci_identity_compartment.compartment.id
  route_table_id             = oci_core_route_table.route_table.id
  prohibit_public_ip_on_vnic = false
  prohibit_internet_ingress  = false
}
