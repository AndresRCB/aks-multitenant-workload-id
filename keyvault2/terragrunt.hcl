include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "..//modules"
}

inputs = {
  resource_group_location    = get_env("demo_location", "eastus2")
  subscription_id            = get_env("demo_subscription_id2")
  tenant_id                  = get_env("demo_tenant_id2")
  resource_group_name_prefix = get_env("demo_resource_group_name_prefix", "rg-aadwi-secondary")
}
