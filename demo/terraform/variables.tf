variable "primary_rg_name" {
  type        = string
  description = "The resource group name of the primary."
}

variable "secondary_rg_name" {
  type        = string
  description = "The resource group name of the secondary."
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created."
  default     = "eastus"
}

variable "application_name_primary" {
  type        = string
  description = "The name of your application"
  default     = "demo-primary-tenant"
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

variable "aks_cluster_name" {
  type        = string
  description = "The name of the aks cluster"
}

variable "kubernetes_namespace_id" {
  type        = string
  description = "Kubernetes namespace"
}

variable "kubernetes_service_account_name" {
  type        = string
  description = "Kubernetes service account name"
}

variable "uai_primary_principal_id" {
  type        = string
  description = "The principal id of primary tenant user assigned managed identity"
}

variable "tenant_id" {
  type        = string
  description = "The primary tenant of aks cluster and event hub1"
}

variable "uai_secondary_principal_id" {
  type        = string
  description = "The principal id of secondary tenant user assigned managed identity"
}

variable "tenant_id2" {
  type        = string
  description = "The secondary tenant of event hub2"
}

variable "subscription_id" {
  type = string
  description = "The subscription id of primary tenant"
}


variable "subscription_id2" {
  type = string
  description = "The subscription id of secondary tenant"
}

variable "application_name_secondary" {
  type        = string
  description = "The name of your application"
  default     = "demo-secondary-tenant"
}

