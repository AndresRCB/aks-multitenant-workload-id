variable "resource_group_name" {
  description = "Name of the preexisting resource group"
}

variable "resource_group_name2" {
  description = "Name of the resource group with the secondary key vault"
}


variable "key_vault_name" {
  description = "Name for the keyvault where the secret to load is stored"
}

variable "key_vault_name2" {
  description = "Name for the secondary key vault"
}

variable "cluster_name" {
  description = "Name of the kubernetes cluster"
}

variable "subscription_id" {
  type = string
  description = "Subscription ID where the resource group and main key vault exist"
}

variable "tenant_id" {
  type = string
  description = "Tenant ID where the resource group and main key vault exist"
}

variable "subscription_id2" {
  type = string
  description = "Subscription ID where the secondary key vault exists"
}

variable "tenant_id2" {
  type = string
  description = "Tenant ID where the secondary key vault exists"
}

variable "secret_name" {
  type = string
  description = "Name of the secret to read in key vault"
}

variable "secret_name2" {
  type = string
  description = "Name of the secret to read in the secondary key vault"
}

variable "kubernetes_namespace_name" {
  description = "Name of the kubernetes namespace to create and use for applications"
  default = "aadwi"
}

variable "kubernetes_service_account_name" {
  description = "Name of the kubernetes service account to create and use for access to Azure resources"
  default = "aadwi-sa"
}
