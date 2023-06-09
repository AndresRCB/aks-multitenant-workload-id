variable "primary_rg_name" {
  type        = string
  description = "The resource group name of the primary."
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created."
  default     = "eastus"
}

variable "application_name_primary" {
  type        = string
  description = "The name of your application"
  default     = "eh-demo-primary-tenant"
}

variable "tag" {
  type        = string
  description = "The value of tag."
  default     = "eh-demo-multitenant"
}

variable "eh_namespace" {
  type        = string
  description = "The name of the event hub namespace"
  default     = "eh-demo-nsp"
}

variable "aks_cluster_id" {
  type        = string
  description = "The aks cluster id to deploy workloads"
}

variable "uai_primary_principal_id" {
  type        = string
  description = "The principal id of primary tenant user assigned managed identity"
}

variable "tenant_id" {
  type        = string
  description = "The primary tenant of aks cluster and event hub1"
}
