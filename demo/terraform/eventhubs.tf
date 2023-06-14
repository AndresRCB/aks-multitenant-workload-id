
# =================== eventhubs primary ================

data "azurerm_client_config" "current" {}

resource "azurecaf_name" "azurecaf_name_eventhubs_primary" {
  name          = var.application_name_primary
  resource_type = "azurerm_eventhub_namespace"
  random_length = 5
  clean_input   = true
}

resource "azurerm_eventhub_namespace" "eventhubs_namespace_primary" {
  name                = azurecaf_name.azurecaf_name_eventhubs_primary.result
  location            = var.location
  resource_group_name = data.azurerm_resource_group.primary.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    terraform                 = "true"
    spring-cloud-azure-sample = var.tag
  }
}

resource "azurerm_eventhub" "eventhubs_primary" {
  name                = "eventhub1"
  namespace_name      = azurerm_eventhub_namespace.eventhubs_namespace_primary.name
  resource_group_name = data.azurerm_resource_group.primary.name
  partition_count     = 2
  message_retention   = 1
}



# =================== eventhubs secondary ================

resource "azurecaf_name" "azurecaf_name_eventhubs_secondary" {
  name          = var.application_name_secondary
  resource_type = "azurerm_eventhub_namespace"
  random_length = 5
  clean_input   = true
}

resource "azurerm_eventhub_namespace" "eventhubs_namespace_secondary" {
  provider = azurerm.second
  name                = azurecaf_name.azurecaf_name_eventhubs_secondary.result
  location            = var.location
  resource_group_name = data.azurerm_resource_group.secondary.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    terraform                 = "true"
    spring-cloud-azure-sample = var.tag
  }
}

resource "azurerm_eventhub" "eventhubs_secondary" {
  provider = azurerm.second
  name                = "eventhub2"
  namespace_name      = azurerm_eventhub_namespace.eventhubs_namespace_secondary.name
  resource_group_name = data.azurerm_resource_group.secondary.name
  partition_count     = 2
  message_retention   = 1
}

