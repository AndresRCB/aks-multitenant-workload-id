variable "subscription_id" {
  type = string
  description = "Subscription ID where the resource group and key vault will be created"
}

variable "tenant_id" {
  type = string
  description = "Tenant ID where the resource group and key vault will be created"
}

variable "key_vault_identity_name" {
  type = string
  description = "Name to give to the managed identity with Key Vault permissions"
  default = "keyvault-client"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg-aadwi-secondary"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}