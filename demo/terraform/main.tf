terraform {
  required_version = "~> 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.42"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.16"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
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

#resource "azurerm_resource_provider_registration" "container_service" {
#  name = "Microsoft.ContainerService"
#
#
#  feature {
#    name       = "EnableWorkloadIdentityPreview"
#    registered = true
#  }
#}

module "aks" {
  source = "./aks"
}

data "azurerm_resource_group" "primary" {
  name = module.aks.resource_group_name
}

module "secondary-setup" {
  source = "./secondary"
}

provider "azurerm" {
  alias = "second"
  subscription_id = var.subscription_id2
  tenant_id = var.tenant_id2

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
  provider = azurerm.second
  name = module.secondary-setup.resource_group_name
}

data "azurerm_kubernetes_cluster" "main" {
  name                = module.aks.cluster_name
  resource_group_name = module.aks.resource_group_name
}

data "azurerm_container_registry" "main" {
  name                = module.aks.acr_name
  resource_group_name = module.aks.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.main.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
}

provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address  = data.azurerm_container_registry.main.login_server
    username = data.azurerm_container_registry.main.admin_username
    password = data.azurerm_container_registry.main.admin_password
  }
}