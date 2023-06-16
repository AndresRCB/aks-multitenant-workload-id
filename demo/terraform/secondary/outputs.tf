output "resource_group_name" {
  value = azurerm_resource_group.main.name
  description = "Name of the created resource group created in second tenant"
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
  description = "Tenant id of the second tenant"
}