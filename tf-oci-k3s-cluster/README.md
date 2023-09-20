# Oracle Cloud Resources Provisioning

This terraform project provisions the following [always-free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) resources on Oracle Cloud (later to be used as infrastructure for a K8S cluster):

Network components:

- Virtual Cloud Network (VCN)

Compute components:

- 4 compute instances

Once `terraform apply` finishes, you may want to note down the following outputs:

1. `db_admin_password`
