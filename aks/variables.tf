variable "authorized_ip_cidr_range" {
  type        = string
  description = "CIDR range from which the cluster nodes and control plane will be reachable"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Name for the test AKS cluster"
  default     = "aks-aad-wi"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg-aks-aad"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
