locals {
  secret_name = "randomSecret"
  secret_value = "AKSWIandKeyVaultIntegrated 2!"
}

data "azurerm_client_config" "current" {}

resource "random_pet" "rg_name" {
  prefix = "rg-aadwi-secondary"
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.rg_name.id
  location = var.resource_group_location
}

resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
  tags = {}
}

resource "azurerm_key_vault_access_policy" "creator" {
  key_vault_id = azurerm_key_vault.main.id
  object_id = data.azurerm_client_config.current.object_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Purge",
    "Recover",
    "Restore"
  ]

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Purge"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge"
  ]
}

resource "azurerm_key_vault_secret" "main" {
  name         = local.secret_name
  value        = local.secret_value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_key_vault_access_policy.creator
  ]
}

