include "root" {
  path = find_in_parent_folders()
}

dependency "aks" {
  config_path = "../aks"
  mock_outputs = {
    resource_group_name = "mock-rg"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

terraform {
  source = "./"
}

inputs = dependency.aks.outputs
