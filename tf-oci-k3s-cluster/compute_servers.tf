resource "oci_core_instance_pool" "servers" {
  display_name              = "k3s-servers"
  compartment_id            = oci_identity_compartment.compartment.id
  instance_configuration_id = oci_core_instance_configuration.server_instance_config.id
  size                      = var.server_count

  placement_configurations {
    availability_domain = var.availability_domain
    primary_vnic_subnets {
      subnet_id = oci_core_subnet.subnet_private.id
    }
  }
}

data "oci_core_instance_pool_instances" "servers" {
  compartment_id   = oci_identity_compartment.compartment.id
  instance_pool_id = oci_core_instance_pool.servers.id
}

data "oci_core_instance" "servers" {
  count = var.server_count
  instance_id = data.oci_core_instance_pool_instances.servers.instances[count.index].id
}

resource "oci_core_instance_configuration" "server_instance_config" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "server-instance-config"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id      = oci_identity_compartment.compartment.id
      availability_domain = var.availability_domain

      shape = var.node_compute_shape
      shape_config {
        memory_in_gbs = var.node_memory_gb
        ocpus         = var.node_cpus
      }

      create_vnic_details {
        subnet_id        = oci_core_subnet.subnet_private.id
        assign_public_ip = false
        nsg_ids          = [oci_core_network_security_group.nodes_nsg.id]
      }

      source_details {
        source_type = "image"
        image_id    = var.node_image_id
      }

      agent_config {
        plugins_config {
          desired_state = "DISABLED"
          name          = "Vulnerability Scanning"
        }

        plugins_config {
          desired_state = "ENABLED"
          name          = "Compute Instance Monitoring"
        }

        plugins_config {
          desired_state = "DISABLED"
          name          = "Bastion"
        }
      }

      metadata = {
        ssh_authorized_keys = file(var.node_instance_ssh_public_key_path)
      }
    }
  }
}
