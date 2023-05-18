variable "kv_key_vault_name" {
  validation {
    condition     = length(var.kv_key_vault_name) < 22  # 24 is max, we add a prefix of kv-
    error_message = "The length of the kv_key_vault_name variable must be 21 or fewer characters."
  }
}

variable "kv_resource_group_name" {
}

variable "kv_tenant_id" {
}

variable "kv_subscription_id" {
}

data "azurerm_client_config" "this" {
  provider = azurerm.current
}

data "azurerm_resource_group" "this" {
  provider = azurerm.current
  name     = var.kv_resource_group_name
}

provider "azurerm" {
  alias           = "current"
  subscription_id = var.kv_subscription_id
  tenant_id       = var.kv_tenant_id
  features {}
}

resource "azurerm_key_vault" "current_kv" {
  provider            = azurerm.current
  name                = "kv-${var.kv_key_vault_name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  tenant_id           = var.kv_tenant_id
  sku_name            = "standard"
  #   enable_rbac_authorization = true
  purge_protection_enabled = false
}

resource "azurerm_key_vault_access_policy" "creator" {
  provider     = azurerm.current
  key_vault_id = azurerm_key_vault.current_kv.id
  object_id    = data.azurerm_client_config.this.object_id
  tenant_id    = data.azurerm_client_config.this.tenant_id

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

output "key_vault_idz" {
  value = azurerm_key_vault.current_kv.id
  description = "Azure Key Vault ID"
}

output "key_vault_namez" {
  value = azurerm_key_vault.current_kv.name
  description = "Azure Key Vault name"
}
