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
  features {}
  tenant_id = var.tenant_id
}

# =================== eventhubs primary ================
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

# =================== storage primary ================

resource "azurecaf_name" "storage_account_primary" {
  name          = var.application_name_primary
  resource_type = "azurerm_storage_account"
  random_length = 5
  clean_input   = true
}

resource "azurerm_storage_account" "storage_account_primary" {
  name                     = azurecaf_name.storage_account_primary.result
  resource_group_name      = var.primary_rg_name
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

// role_assignment
resource "azurerm_role_assignment" "role_storage_account_contributor_main" {
  scope                = azurerm_storage_account.storage_account_primary.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.uai_primary_principal_id
}

resource "azurerm_role_assignment" "role_storage_blob_data_owner_main" {
  scope                = azurerm_storage_container.storage_container_primary.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.uai_primary_principal_id
}

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

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = var.uai_primary_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}

resource "kubernetes_deployment" "publisher" {
  metadata {
    name = "publisher"
    labels = {
    }
    namespace = var.kubernetes_namespace_name
  }
    spec {
      replicas = 2

      selector {
        match_labels = {
          test = "publisher"
        }
      }
      template {
        metadata {
          labels = {
            test                          = "publisher",
            "azure.workload.identity/use" = "true"
          }
        }
      }
      spec {
        node_selector = {
          agentpool = local.app_node_pool_name
        }

        service_account_name = var.kubernetes_service_account_name

        container {
          image = local.publisher_image
          name  = "publisher"
          liveness_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = 8080
            }
            initial_delay_seconds = 60
            period_seconds        = 5
            failure_threshold     = 10
          }

          # General Config
          env {
            name  = "..."
            value = "..."
          }
        }
      }
    }
  }   
