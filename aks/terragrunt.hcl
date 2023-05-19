include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = ".///"

}

inputs = {
  resource_group_location    = get_env("demo_location", "eastus2")
  cluster_name               = get_env("demo_cluster_name", "aks-aad-wi")
  resource_group_name_prefix = get_env("demo_resource_group_name_prefix", "rg-aks-aad")
}
