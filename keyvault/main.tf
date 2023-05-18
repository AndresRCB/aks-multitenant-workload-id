locals {
  secret_name = "randomSecret"
  secret_value = "AKSWIandKeyVaultIntegrated!"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "random_pet" "test_name_1" {
  length    = 2
  separator = "-"
  prefix    = "one"
}

module "key_vault_one" {
  source                 = "../modules/keyvault"
  kv_resource_group_name = data.azurerm_resource_group.main.name
  kv_key_vault_name      = random_pet.test_name_1.id
  kv_tenant_id           = data.azurerm_client_config.current.tenant_id
  kv_subscription_id     = data.azurerm_client_config.current.subscription_id
}

resource "azurerm_key_vault_secret" "main" {
  name         = local.secret_name
  value        = local.secret_value
  key_vault_id = module.key_vault_one.key_vault_idz
}

