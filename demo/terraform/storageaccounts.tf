# =================== storage primary ================

resource "azurecaf_name" "storage_account_primary" {
  name          = var.application_name_primary
  resource_type = "azurerm_storage_account"
  random_length = 5
  clean_input   = true
}

resource "azurerm_storage_account" "storage_account_primary" {
  name                     = azurecaf_name.storage_account_primary.result
  resource_group_name      = var.primary_rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    "terraform"                 = "true"
    spring-cloud-azure-sample  = var.tag
  }
}

resource "azurerm_storage_container" "storage_container_primary" {
  name                  = "eventhubs-binder-sample"
  storage_account_name  = azurerm_storage_account.storage_account_primary.name
  container_access_type = "container"
}

// role_assignment
resource "azurerm_role_assignment" "role_storage_account_contributor_main" {
  scope                = azurerm_storage_account.storage_account_primary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.uai_primary_principal_id
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_main" {
  scope                = azurerm_storage_container.storage_container_primary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.uai_primary_principal_id
}

# =================== storage secondary ================

resource "azurecaf_name" "storage_account_secondary" {
  name          = var.application_name_secondary
  resource_type = "azurerm_storage_account"
  random_length = 5
  clean_input   = true
}

resource "azurerm_storage_account" "storage_account_secondary" {
  provider = azurerm.second
  name                     = azurecaf_name.storage_account_secondary.result
  resource_group_name      = data.azurerm_resource_group.secondary.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    "terraform"                 = "true"
    spring-cloud-azure-sample  = var.tag
  }
}

resource "azurerm_storage_container" "storage_container_secondary" {
  provider = azurerm.second
  name                  = "eventhubs-binder-sample"
  storage_account_name  = azurerm_storage_account.storage_account_secondary.name
  container_access_type = "container"
}

// role_assignment
resource "azurerm_role_assignment" "role_storage_account_contributor_secondary" {
  provider = azurerm.second
  scope                = azurerm_storage_account.storage_account_secondary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.uai_secondary_principal_id
  //delegated_managed_identity_resource_id = "/subscriptions/7b462068-95e0-4334-876a-13455cfbad46/resourcegroups/rg-aadwi-secondary-one-jaybird/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-kv-tough-sawfly"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_secondary" {
  provider = azurerm.second
  scope                = azurerm_storage_container.storage_container_secondary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.uai_secondary_principal_id
  //delegated_managed_identity_resource_id = "/subscriptions/7b462068-95e0-4334-876a-13455cfbad46/resourcegroups/rg-aadwi-secondary-one-jaybird/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-kv-tough-sawfly"
  skip_service_principal_aad_check = true
}