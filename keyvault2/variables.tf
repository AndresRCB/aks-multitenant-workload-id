variable "subscription_id2" {
  type = string
  description = "Subscription ID where the resource group and key vault will be created"
}

variable "tenant_id2" {
  type = string
  description = "Tenant ID where the resource group and key vault will be created"
}

# variable "key_vault_name2" {
#   type = string
#   description = "Globally unique name to give to the Key Vault instance"
# }

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
