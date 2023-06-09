
variable "secondary_rg_name" {
  type        = string
  description = "The resource group name of the secondary."
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created."
  default     = "eastus"
}

variable "application_name_secondary" {
  type        = string
  description = "The name of your application"
  default     = "eh-demo-secondary-tenant"
}


variable "tag" {
  type        = string
  description = "The value of tag."
  default     = "eh-demo-multitenant"
}

variable "uai_secondary_principal_id" {
  type        = string
  description = "The principal id of secondary tenant user assigned managed identity"
}

variable "tenant_id2" {
  type        = string
  description = "The secondary tenant of event hub2"
}

variable "subscriptionid_2" {
  type = string
  description = "The subscription id of secondary tenant"
}