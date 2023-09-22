resource "random_password" "db_admin_password" {
  length = 16
}

output "db_admin_password" {
  value     = random_password.db_admin_password.result
  sensitive = true
}

resource "oci_database_autonomous_database" "database" {
  count = 0
  compartment_id = oci_identity_compartment.compartment.id
  db_name        = "clusterdb"
  admin_password = random_password.db_admin_password.result
  db_workload    = "OLTP"
  db_version     = "19c"
  is_free_tier   = true
  whitelisted_ips = ["${oci_core_vcn.vcn.id};${oci_core_subnet.subnet_private.cidr_block}"]
}
