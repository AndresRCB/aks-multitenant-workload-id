# =================== publisher rbac in main tenant ================

resource "random_pet" "uai_name_publish" {
  prefix = "uai-publish-main"
  length = 2
}

resource "azurerm_user_assigned_identity" "main-publisher" {
  name                = random_pet.uai_name_publish.id
  resource_group_name = data.azurerm_resource_group.primary.name
  location            = var.location
}

resource "azurerm_role_assignment" "role_eventhubs_data_sender_main_tenant" {
  scope                = azurerm_eventhub.eventhubs_primary.id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_user_assigned_identity.main-publisher.principal_id
}

resource "azurerm_role_assignment" "role_storage_account_contributor_main" {
  scope                = azurerm_storage_account.storage_account_primary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.main-publisher.principal_id
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_main" {
  scope                = azurerm_storage_container.storage_container_primary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.main-publisher.principal_id
}

# =================== subscriber rbac in main tenant ================

resource "random_pet" "uai_name_subscribe" {
  prefix = "uai-subscribe-main"
  length = 2
}

resource "azurerm_user_assigned_identity" "main-subscriber" {
  name                = random_pet.uai_name_subscribe.id
  resource_group_name = data.azurerm_resource_group.primary.name
  location            = var.location

}

resource "azurerm_role_assignment" "role_eventhubs_data_rec_main_tenant" {
  scope                = azurerm_eventhub.eventhubs_primary.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_user_assigned_identity.main-subscriber.principal_id
}

resource "azurerm_role_assignment" "role_storage_account_contributor_sub_main" {
  scope                = azurerm_storage_account.storage_account_primary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.main-subscriber.principal_id
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_sub_main" {
  scope                = azurerm_storage_container.storage_container_primary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.main-subscriber.principal_id
}
