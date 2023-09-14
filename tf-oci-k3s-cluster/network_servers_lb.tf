# Load balancer over the servers

# load balancer
resource "oci_load_balancer_load_balancer" "servers_lb" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "servers-lb"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.subnet_private.id]
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }
  ip_mode    = "IPV4"
  is_private = true
}

resource "oci_load_balancer_listener" "servers_lb_kubeapi_listener" {
  name                     = "servers-lb-kubeapi-listener"
  load_balancer_id         = oci_load_balancer_load_balancer.servers_lb.id
  default_backend_set_name = oci_load_balancer_backend_set.servers_lb_backend_set.name
  port                     = 6443
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend_set" "servers_lb_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.servers_lb.id
  name             = "servers-lb-backend-set"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 6443
  }
}

resource "oci_load_balancer_backend" "servers_lb_backend" {
  count = var.server_count

  backendset_name  = oci_load_balancer_backend_set.servers_lb_backend_set.name
  load_balancer_id = oci_load_balancer_load_balancer.servers_lb.id
  ip_address       = data.oci_core_instance.servers[count.index].private_ip
  port             = 6443
}
