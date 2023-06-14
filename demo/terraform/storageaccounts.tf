# =================== storage primary ================

resource "azurecaf_name" "storage_account_primary" {
  name          = var.application_name_primary
  resource_type = "azurerm_storage_account"
  random_length = 5
  clean_input   = true
}

resource "azurerm_storage_account" "storage_account_primary" {
  name                     = azurecaf_name.storage_account_primary.result
  resource_group_name      = data.azurerm_resource_group.primary.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    "terraform"                 = "true"
    spring-cloud-azure-sample  = var.tag
  }
}

resource "azurerm_storage_container" "storage_container_primary" {
  name                  = "eventhubs-binder-sample"
  storage_account_name  = azurerm_storage_account.storage_account_primary.name
  container_access_type = "container"
}

# =================== storage secondary ================

resource "azurecaf_name" "storage_account_secondary" {
  name          = var.application_name_secondary
  resource_type = "azurerm_storage_account"
  random_length = 5
  clean_input   = true
}

resource "azurerm_storage_account" "storage_account_secondary" {
  provider = azurerm.second
  name                     = azurecaf_name.storage_account_secondary.result
  resource_group_name      = data.azurerm_resource_group.secondary.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    "terraform"                 = "true"
    spring-cloud-azure-sample  = var.tag
  }
}

resource "azurerm_storage_container" "storage_container_secondary" {
  provider = azurerm.second
  name                  = "eventhubs-binder-sample"
  storage_account_name  = azurerm_storage_account.storage_account_secondary.name
  container_access_type = "container"
}