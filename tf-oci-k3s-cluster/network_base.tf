# Virtual Cloud Network
# This is where all the resources will be created for the cluster -
# e.g. nodes, load balancers, etc.
resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = var.vcn_display_name
}

# This will provide the VCN with internet access
resource "oci_core_nat_gateway" "nat" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = true
}

# Route all outbound traffic from the VCN public subnet through the ig
resource "oci_core_route_table" "route_table_public" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

# Route all outbound traffic from the VCN private subnet through the nat
resource "oci_core_route_table" "route_table_private" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
}

# We allocate IP addresses compute instances from this subnet
resource "oci_core_subnet" "subnet_private" {
  cidr_block                 = var.subnet_cidr_block_private
  vcn_id                     = oci_core_vcn.vcn.id
  compartment_id             = oci_identity_compartment.compartment.id
  route_table_id             = oci_core_route_table.route_table_private.id
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
  security_list_ids = [
    oci_core_default_security_list.default_security_list.id,
  ]
}

resource "oci_core_subnet" "subnet_public" {
  cidr_block                 = var.subnet_cidr_block_public
  vcn_id                     = oci_core_vcn.vcn.id
  compartment_id             = oci_identity_compartment.compartment.id
  route_table_id             = oci_core_route_table.route_table_public.id
  prohibit_public_ip_on_vnic = false
  prohibit_internet_ingress  = false
  security_list_ids = [
    oci_core_default_security_list.default_security_list.id,
  ]
}

resource "oci_core_default_security_list" "default_security_list" {
  compartment_id             = oci_identity_compartment.compartment.id
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    source   = var.vcn_cidr_block
    protocol = "all"
  }
}
