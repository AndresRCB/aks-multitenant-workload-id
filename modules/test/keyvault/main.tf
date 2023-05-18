### NOTES
# set TF_VAR_  ENV vars for TF variables
# export TF_VAR_tenant_id_1=""
# export TF_VAR_subscription_id_1=""
# export TF_VAR_tenant_id_2=""
# export TF_VAR_subscription_id_2=""
# export AZURE_CONFIG_DIR="$PWD/.azure"

# login via:
# az login --allow-no-subscriptions --tenant $TF_VAR_tenant_id_1
# az login --allow-no-subscriptions --tenant $TF_VAR_tenant_id_2

# you should see two subs via az cli
# az account list -o table --all --query "[].{TenantID: tenantId, Subscription: name, Default: isDefault, ID: id}"

# terraform apply --auto-approve

terraform {
  required_version = "~> 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.56"
    }
  }
}

provider "azurerm" {
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

variable "tenant_id" {
  description = "tenant id 1"
}

variable "subscription_id" {
  description = "first subscription id"
}

variable "tenant_id2" {
  description = "tenant id 2"
}

variable "subscription_id2" {
  description = "second subscription id"
}

data "external" "current_user" {
  program = ["bash", "-c", "echo '{\"user\": \"'$USER'\"}'"]

}

provider "azurerm" {
  alias           = "dev-sub1"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

provider "azurerm" {
  alias           = "dev-sub2"
  subscription_id = var.subscription_id2
  tenant_id       = var.tenant_id2
  features {}
}

locals {
  location = "eastus2"
}

resource "random_pet" "test_name_1" {
  length    = 2
  separator = "-"
  prefix    = "one"
}

resource "random_pet" "test_name_2" {
  length    = 2
  separator = "-"
  prefix    = "two"
}

resource "azurerm_resource_group" "test_rg_1" {
  name = join("-", [data.external.current_user.result["user"], "rg", "${random_pet.test_name_1.id}"])
  location = local.location
  provider = azurerm.dev-sub1
}

resource "azurerm_resource_group" "test_rg_2" {
  name = join("-", [data.external.current_user.result["user"], "rg", "${random_pet.test_name_2.id}"])
  location = local.location
  provider = azurerm.dev-sub2
}


module "key_vault_one" {
  source                 = "../../../modules/keyvault"
  kv_resource_group_name = azurerm_resource_group.test_rg_1.name
  kv_key_vault_name      = random_pet.test_name_1.id
  kv_tenant_id           = var.tenant_id
  kv_subscription_id     = var.subscription_id
}

module "key_vault_two" {
  source                 = "../../../modules/keyvault"
  kv_resource_group_name = azurerm_resource_group.test_rg_2.name
  kv_key_vault_name      = random_pet.test_name_2.id
  kv_tenant_id           = var.tenant_id2
  kv_subscription_id     = var.subscription_id2
}
