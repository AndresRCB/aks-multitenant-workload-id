variable "authorized_ip_cidr_range" {
  type        = string
  description = "CIDR range from which the cluster nodes and control plane will be reachable"
  default     = ""
}

variable "cluster_dns_prefix" {
  type        = string
  description = "DNS prefix for AKS cluster"
  default     = "aksmultitenanttest"
}

variable "cluster_dns_service_ip_address" {
  type        = string
  description = "IP address for the cluster's DNS service"
  default     = "172.16.16.254"
}

variable "cluster_name" {
  type        = string
  description = "Name for the test AKS cluster"
  default     = "aksmultitenant-cluster"
}

variable "cluster_node_count" {
  description = "Desired number of nodes in the cluster"
  default = 2
}

variable "cluster_sku_tier" {
  type        = string
  description = "SKU tier selection between Free and Paid"
  default     = "Free"
}

variable "cluster_service_ip_range" {
  type        = string
  description = "CIDR range for the cluster's kube-system services"
  default     = "172.16.16.0/24"
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "Size of nodes in the k8s cluster's default node pool"
  default     = "standard_d2a_v4"
}

variable "resource_group_location" {
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "ire"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for the cluster subnet (note that must be part of the vnet_cidr range)"
  default     = "172.16.0.0/20"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet where all resources will be"
  default     = "subnet-dps-test"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the virtual network"
  default     = "172.16.0.0/16"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network where all resources will be"
  default     = "vnet-dps-test"
}
