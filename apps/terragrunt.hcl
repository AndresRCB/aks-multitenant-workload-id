include "root" {
  path = find_in_parent_folders()
}

dependency "aks" {
  config_path = "../aks"
  mock_outputs = {
    resource_group_name = "mock-rg"
    cluster_name = "mock-aks"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

dependency "keyvault" {
  config_path = "../keyvault"
  mock_outputs = {
    secret_name = "mock-secret"
    key_vault_name = "mock-keyvault"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

dependency "keyvault2" {
  config_path = "../keyvault2"
  mock_outputs = {
    secret_name = "mock-secret"
    key_vault_name = "mock-keyvault"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}


terraform {
  source = ".//"
}

inputs = merge(dependency.aks.outputs, dependency.keyvault.outputs, {
  resource_group_name2 = dependency.keyvault2.outputs.resource_group_name
  key_vault_name2 = dependency.keyvault2.outputs.key_vault_name
  secret_name2 = dependency.keyvault2.outputs.secret_name
})
