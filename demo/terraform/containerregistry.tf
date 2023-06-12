resource "random_pet" "acr_name" {
  length    = 2
  separator = ""
}

resource "azurerm_container_registry" "main" {
  name                = "${random_pet.acr_name.id}demo"
  resource_group_name = var.primary_rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

//todo acr pull access for kubernetes
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = var.uai_primary_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}


