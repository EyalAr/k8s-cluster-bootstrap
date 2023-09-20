# set up public access into the cluster with a network load balancer

resource "oci_network_load_balancer_network_load_balancer" "public_nlb" {
  depends_on                     = [data.oci_core_instance.server, data.oci_core_instance.agents]
  compartment_id                 = oci_identity_compartment.compartment.id
  display_name                   = "public-nlb"
  subnet_id                      = oci_core_subnet.subnet_public.id
  is_private                     = false
  is_preserve_source_destination = false
  network_security_group_ids     = [oci_core_network_security_group.public_nlb_nsg.id]
}

################
# HTTP TRAFFIC #
################

resource "oci_network_load_balancer_listener" "public_nlb_http_listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  name                     = "public-nlb-http-listener"
  protocol                 = "TCP"
  port                     = 80
  default_backend_set_name = oci_network_load_balancer_backend_set.public_nlb_http_backend_set.name
}

resource "oci_network_load_balancer_backend_set" "public_nlb_http_backend_set" {
  name                     = "public-nlb-http-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol = "TCP"
    port     = 80
  }
}

resource "oci_network_load_balancer_backend" "public_nlb_http_backend_server" {
  backend_set_name         = oci_network_load_balancer_backend_set.public_nlb_http_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  target_id                = data.oci_core_instance.server.id
  port                     = 80
}

resource "oci_network_load_balancer_backend" "public_nlb_http_backend_agents" {
  count = 3

  backend_set_name         = oci_network_load_balancer_backend_set.public_nlb_http_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  target_id                = data.oci_core_instance.agents[count.index].id
  port                     = 80
}

#################
# HTTPS TRAFFIC #
#################

resource "oci_network_load_balancer_listener" "public_nlb_https_listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  name                     = "public-nlb-https-listener"
  protocol                 = "TCP"
  port                     = 443
  default_backend_set_name = oci_network_load_balancer_backend_set.public_nlb_https_backend_set.name
}

resource "oci_network_load_balancer_backend_set" "public_nlb_https_backend_set" {
  name                     = "public-nlb-https-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol = "TCP"
    port     = 443
  }
}

resource "oci_network_load_balancer_backend" "public_nlb_https_backend_server" {
  backend_set_name         = oci_network_load_balancer_backend_set.public_nlb_https_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  target_id                = data.oci_core_instance.server.id
  port                     = 443
}

resource "oci_network_load_balancer_backend" "public_nlb_https_backend_agents" {
  count = 3

  backend_set_name         = oci_network_load_balancer_backend_set.public_nlb_https_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  target_id                = data.oci_core_instance.agents[count.index].id
  port                     = 443
}

###################
# KUBEAPI TRAFFIC #
###################

resource "oci_network_load_balancer_listener" "public_nlb_kubeapi_listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  name                     = "public-nlb-kubeapi-listener"
  protocol                 = "TCP"
  port                     = 6443
  default_backend_set_name = oci_network_load_balancer_backend_set.public_nlb_kubeapi_backend_set.name
}

resource "oci_network_load_balancer_backend_set" "public_nlb_kubeapi_backend_set" {
  name                     = "public-nlb-kubeapi-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol = "TCP"
    port     = 6443
  }
}

resource "oci_network_load_balancer_backend" "public_nlb_kubeapi_backend_server" {
  backend_set_name         = oci_network_load_balancer_backend_set.public_nlb_kubeapi_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_nlb.id
  target_id                = data.oci_core_instance.server.id
  port                     = 6443
}
