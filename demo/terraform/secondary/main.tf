data "azurerm_client_config" "current" {}

resource "random_pet" "rg_name" {
  prefix = "rg-aadwi-secondary"
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.rg_name.id
  location = var.resource_group_location
}

