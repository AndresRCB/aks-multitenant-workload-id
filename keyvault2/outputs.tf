output "key_vault_id" {
  value = module.key_vault_two.key_vault_idz
  description = "Azure Key Vault ID"
}

output "key_vault_name" {
  value = module.key_vault_two.key_vault_namez
  description = "Azure Key Vault name"
}

output "secret_name" {
  value = local.secret_name
  description = "Name of secret to create for app testing"
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
  description = "Name of the created resource group that contains the secondary key vault"
}