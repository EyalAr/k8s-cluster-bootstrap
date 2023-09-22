resource "oci_core_network_security_group" "public_nlb_nsg" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
}

# Allow incoming http traffic from the public internet
resource "oci_core_network_security_group_security_rule" "lb_allow_http" {
  network_security_group_id = oci_core_network_security_group.public_nlb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

# Allow incoming https traffic from the public internet
resource "oci_core_network_security_group_security_rule" "lb_allow_https" {
  network_security_group_id = oci_core_network_security_group.public_nlb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

# Allow incoming kubeapi connections (port 6443) from the public internet
resource "oci_core_network_security_group_security_rule" "lb_allow_kubeapi" {
  network_security_group_id = oci_core_network_security_group.public_nlb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}
