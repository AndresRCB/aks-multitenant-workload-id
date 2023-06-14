variable "subscription_id" {
  type = string
  description = "Subscription ID where the resource group and key vault will be created"
  default = "7b462068-95e0-4334-876a-13455cfbad46"
}

variable "tenant_id" {
  type = string
  description = "Tenant ID where the resource group and key vault will be created"
  default = "c6f611ba-1194-4d79-999b-f32948c809a5"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus2"
  description = "Location of the resource group."
}
