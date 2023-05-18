variable "resource_group_name" {
  type = string
  description = "Name of the resource group where the AKS cluster and Azure Key Vault are"
}

variable "key_vault_identity_name" {
  type = string
  description = "Name to give to the managed identity with Key Vault permissions"
  default = "keyvault-client"
}
