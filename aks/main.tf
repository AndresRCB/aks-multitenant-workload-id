resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "main" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

module "public_aks_cluster" {
  source = "github.com/AndresRCB/aks-public-cluster"

  resource_group_name = azurerm_resource_group.main.name
  cluster_name = var.cluster_name
  authorized_ip_cidr_range = var.authorized_ip_cidr_range
  default_node_pool_vm_size = "standard_d2a_v4"

  depends_on = [
    azurerm_resource_group.main
  ]
}
