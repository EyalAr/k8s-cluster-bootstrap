resource "oci_core_network_security_group" "nodes_nsg" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_network_security_group_security_rule" "allow_http_from_load_balancer" {
  network_security_group_id = oci_core_network_security_group.nodes_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = oci_core_network_security_group.public_nlb_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_https_from_load_balancer" {
  network_security_group_id = oci_core_network_security_group.nodes_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = oci_core_network_security_group.public_nlb_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_kubeapi_from_load_balancer" {
  network_security_group_id = oci_core_network_security_group.nodes_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = oci_core_network_security_group.public_nlb_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}
