resource "oci_bastion_bastion" "bastion" {
  compartment_id               = oci_identity_compartment.compartment.id
  target_subnet_id             = oci_core_subnet.subnet_private.id
  bastion_type                 = "STANDARD"
  client_cidr_block_allow_list = ["0.0.0.0/0"]
}

resource "oci_bastion_session" "bastion_session" {
  bastion_id = oci_bastion_bastion.bastion.id
  key_details {
    public_key_content = file(var.node_instance_ssh_public_key_path)
  }
  session_ttl_in_seconds = 1800
  target_resource_details {
    session_type         = "PORT_FORWARDING"
    target_resource_id   = data.oci_core_instance.server.id
    target_resource_port = 22
  }
}


module "kubectl_config" {
  source  = "Invicton-Labs/shell-data/external"
  version = "0.4.2"
  command_unix = templatefile("${path.module}/scripts/get_kubeconfig.sh", {
    bastion_session_ocid   = oci_bastion_session.bastion_session.id,
    bastion_region_id      = var.region_id,
    local_port             = 9922
    private_key_local_path = "~/.ssh/id_ed25519"
    server_private_ip      = "10.0.0.146"
  })
  suppress_console = true
}

output "kubectl_config" {
  value     = replace(module.kubectl_config.stdout, "127.0.0.1", var.domain)
  sensitive = true
}
