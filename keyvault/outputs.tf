output "key_vault_id" {
  value = azurerm_key_vault.main.id
  description = "Azure Key Vault ID"
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
  description = "Azure Key Vault name"
}

output "secret_name" {
  value = local.secret_name
  description = "Name of secret to create for app testing"
}
