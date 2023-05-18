include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "..//modules"
}

#inputs = {
#    tenant_id2 = "kv2tenant" #get_env("TF_VAR_tenant_id2")
#    subscription_id2 = "kv2sub" # get_env("TF_VAR_subscription_id2")
#}

