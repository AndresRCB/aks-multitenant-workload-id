
# =================== publisher access in secondary tenant ================

resource "random_pet" "uai_secondary" {
  prefix = "uai-secondary"
  length = 2
}

resource "azurerm_user_assigned_identity" "secondary" {
  provider = azurerm.second
  name                = random_pet.uai_secondary.id
  resource_group_name = data.azurerm_resource_group.secondary.name
  location            = data.azurerm_resource_group.secondary.location

  depends_on = [module.secondary-setup]
}

resource "azurerm_role_assignment" "role_eventhubs_data_sub_secondary_tenant" {
  provider = azurerm.second
  scope                = azurerm_eventhub.eventhubs_secondary.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_user_assigned_identity.secondary.principal_id
  //delegated_managed_identity_resource_id = "/subscriptions/7b462068-95e0-4334-876a-13455cfbad46/resourcegroups/rg-aadwi-secondary-one-jaybird/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-kv-tough-sawfly"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "role_storage_account_contributor_sub_secondary" {
  provider = azurerm.second
  scope                = azurerm_storage_account.storage_account_secondary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         =  azurerm_user_assigned_identity.secondary.principal_id
  //delegated_managed_identity_resource_id = "/subscriptions/7b462068-95e0-4334-876a-13455cfbad46/resourcegroups/rg-aadwi-secondary-one-jaybird/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-kv-tough-sawfly"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_sub_secondary" {
  provider = azurerm.second
  scope                = azurerm_storage_container.storage_container_secondary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         =  azurerm_user_assigned_identity.secondary.principal_id
  //delegated_managed_identity_resource_id = "/subscriptions/7b462068-95e0-4334-876a-13455cfbad46/resourcegroups/rg-aadwi-secondary-one-jaybird/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-kv-tough-sawfly"
  skip_service_principal_aad_check = true
}