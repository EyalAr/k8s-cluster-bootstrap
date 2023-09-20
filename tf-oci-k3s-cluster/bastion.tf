resource "oci_bastion_bastion" "bastion" {
    compartment_id = oci_identity_compartment.compartment.id
    target_subnet_id = oci_core_subnet.subnet_private.id
    bastion_type = "STANDARD"
    client_cidr_block_allow_list = ["0.0.0.0/0"]
}

# resource "oci_bastion_session" "bastion_session" {
#     count = 0
#     bastion_id = oci_bastion_bastion.bastion.id
#     key_details {
#       public_key_content = file(var.node_instance_ssh_public_key_path)
#     }
#     session_ttl_in_seconds = 120
#     target_resource_details {
#       session_type = "PORT_FORWARDING"
#     }
# }