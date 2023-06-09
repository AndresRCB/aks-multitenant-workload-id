terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.16"
    }
  }
}

provider "azurerm" {
  alias = "secondry"
  tenant_id = var.tenant_id2
  subscription_id = var.subscriptionid_2
  
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    application_insights {
      disable_generated_rule = true
    }

    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_resource_group" "secondary" {
  provider = azurerm.secondry
  name     = var.secondary_rg_name
}

# =================== eventhubs secondary ================

resource "azurecaf_name" "azurecaf_name_eventhubs_secondary" {
  name          = var.application_name_secondary
  resource_type = "azurerm_eventhub_namespace"
  random_length = 5
  clean_input   = true
}

resource "azurerm_eventhub_namespace" "eventhubs_namespace_secondary" {
  provider = azurerm.secondry
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
  provider = azurerm.secondry
  name                = "eventhub2"
  namespace_name      = azurerm_eventhub_namespace.eventhubs_namespace_secondary.name
  resource_group_name = data.azurerm_resource_group.secondary.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_role_assignment" "role_eventhubs_data_owner_secondary_tenant" {
  scope                = azurerm_eventhub.eventhubs_secondary.id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = var.uai_secondary_principal_id
  delegated_managed_identity_resource_id = format("%s|%s",azurerm_eventhub.eventhubs_secondary.id,var.tenant_id2)
}

# =================== storage secondary ================

resource "azurecaf_name" "storage_account_secondary" {
  name          = var.application_name_secondary
  resource_type = "azurerm_storage_account"
  random_length = 5
  clean_input   = true
}

resource "azurerm_storage_account" "storage_account_secondary" {
  provider = azurerm.secondry
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
  provider = azurerm.secondry
  name                  = "eventhubs-binder-sample"
  storage_account_name  = azurerm_storage_account.storage_account_secondary.name
  container_access_type = "container"
}

// role_assignment
resource "azurerm_role_assignment" "role_storage_account_contributor_secondary" {
  scope                = azurerm_storage_account.storage_account_secondary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.uai_secondary_principal_id
  delegated_managed_identity_resource_id = format("%s|%s", azurerm_storage_account.storage_account_secondary.id, var.tenant_id2)
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_secondary" {
  scope                = azurerm_storage_container.storage_container_secondary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.uai_secondary_principal_id
  delegated_managed_identity_resource_id = format("%s|%s", azurerm_storage_container.storage_container_secondary.resource_manager_id, var.tenant_id2)
}



