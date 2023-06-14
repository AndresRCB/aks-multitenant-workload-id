output "AZURE_EVENTHUBS_NAMESPACE_PRIMARY" {
  value       = azurerm_eventhub_namespace.eventhubs_namespace_primary.name
  description = "The event hubs namespace in primary tenant."
}

output "AZURE_EVENTHUB_NAME_PRIMARY" {
  value       = azurerm_eventhub.eventhubs_primary.name
  description = "The name of created event hubs in primary tenant."
}

output "AZURE_STORAGE_ACCOUNT_NAME_PRIMARY" {
  value       = azurerm_storage_account.storage_account_primary.name
  description = "The storage account name in primary tenant."
}

output "AZURE_STORAGE_CONTAINER_NAME_PRIMARY" {
  value       = azurerm_storage_container.storage_container_primary.name
  description = "The container name created in storage account in primary tenant."
}

output "AZURE_EVENTHUB_NAME_SECONDARY" {
  value       = azurerm_eventhub.eventhubs_secondary.name
  description = "The name of created event hubs in secondary tenant."
}

output "AZURE_STORAGE_ACCOUNT_NAME_SECONDARY" {
  value       = azurerm_storage_account.storage_account_secondary.name
  description = "The storage account name in secondary tenant."
}

output "AZURE_STORAGE_CONTAINER_NAME_SECONDARY" {
  value       = azurerm_storage_container.storage_container_secondary.name
  description = "The container name created in storage account in secondary tenant."
}

# the default consumer group
output "AZURE_EVENTHUB_CONSUMER_GROUP_PRIMARY" {
  value       = "$Default"
  description = "The value of default consumer group in primary tenant."
}

output "AZURE_CONTAINER_REGISTRY" {
  value       = "$Default"
  description = "The value of default consumer group in primary tenant."
}

