output "resource_group_name" {
  value = azurerm_resource_group.main.name
  description = "Name of the created resource group created in second tenant"
}