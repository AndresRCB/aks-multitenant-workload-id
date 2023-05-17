variable "resource_group_name" {
  description = "Name of the preexisting resource group"
}

variable "key_vault_name" {
  description = "Name for the keyvault where the secret to load is stored"
}

variable "cluster_name" {
  description = "Name of the kubernetes cluster"
}

variable "secret_name" {
  type = string
  description = "Name of the secret to read in key vault"
}

variable "kubernetes_namespace_name" {
  description = "Name of the kubernetes namespace to create and use for applications"
  default = "aadwi"
}

variable "kubernetes_service_account_name" {
  description = "Name of the kubernetes service account to create and use for access to Azure resources"
  default = "aadwi-sa"
}
