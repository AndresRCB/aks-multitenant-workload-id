# Prerequisites

- Az login to your tenant and set to your subscription.
- Set up the multi tenant environment resources as per the README instructions
  located at the root of this workspace to configure the multi-tenant environment.


# Create infrastructure

Please create the required variables in `terraform.tfvars` in the /demo folder. Use the resourcegroup
created from the multi tenant env set up.

```terraform
primary_rg_name = ""
secondary_rg_name = ""
aks_cluster_id = ""
uai_primary_principal_id = ""
uai_secondary_principal_id = ""
tenant_id2 = ""
tenant_id = ""
```
