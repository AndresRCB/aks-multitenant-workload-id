data "azurerm_resource_group" "secondary" {
  provider = azurerm.second
  name     = var.secondary_rg_name
}


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
  resource_group_name = var.primary_rg_name
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
  resource_group_name = var.primary_rg_name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_role_assignment" "role_eventhubs_data_owner_main_tenant" {
  scope                = azurerm_eventhub.eventhubs_primary.id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = var.uai_primary_principal_id
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

resource "azurerm_role_assignment" "role_eventhubs_data_owner_secondary_tenant" {
  provider = azurerm.second
  scope                = azurerm_eventhub.eventhubs_secondary.id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = var.uai_secondary_principal_id
  //delegated_managed_identity_resource_id = "/subscriptions/7b462068-95e0-4334-876a-13455cfbad46/resourcegroups/rg-aadwi-secondary-one-jaybird/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-kv-tough-sawfly"
  skip_service_principal_aad_check = true
}