locals {
  secret_name  = "randomSecret"
  secret_value = "AKSWIandKeyVaultIntegrated 2!"
}

data "azurerm_client_config" "current" {}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_pet" "kv_name" {
  length    = 2
  separator = "-"
}

resource "azurerm_resource_group" "main" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

module "key_vault_two" {
  source                 = "../modules/keyvault"
  kv_resource_group_name = azurerm_resource_group.main.name
  kv_key_vault_name      = random_pet.kv_name.id
  kv_tenant_id           = var.tenant_id
  kv_subscription_id     = var.subscription_id
}

resource "azurerm_key_vault_secret" "main" {
  name         = local.secret_name
  value        = local.secret_value
  key_vault_id = module.key_vault_two.key_vault_idz
}

