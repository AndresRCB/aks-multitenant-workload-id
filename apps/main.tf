data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_key_vault" "main" {
  name = var.key_vault_name
  resource_group_name = var.resource_group_name
}

resource "random_pet" "sp_name" {
  prefix = "uai-kv"
  length = 2
}

resource "azuread_application" "main" {
  display_name = random_pet.sp_name.id
  sign_in_audience = "AzureADMultipleOrgs"
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "azuread_application_federated_identity_credential" "main" {
  application_object_id = azuread_application.main.object_id
  display_name          = "aks-kv"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = data.azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject               = "system:serviceaccount:${var.kubernetes_namespace_name}:${var.kubernetes_service_account_name}"

  depends_on = [
    kubernetes_service_account.main,
    data.azurerm_kubernetes_cluster.main
  ]
}

# Need a delay because federated identity credentials shouldn't be used right after creation (must wait a few seconds)
resource "time_sleep" "federated_identity_credential" {
  depends_on = [azuread_application_federated_identity_credential.main]
  create_duration = "30s"
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = data.azurerm_key_vault.main.id
  object_id = azuread_service_principal.main.object_id
  tenant_id = var.tenant_id
  
  certificate_permissions = [
    "Get",
  ]

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get"
  ]
}
