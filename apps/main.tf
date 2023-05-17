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

resource "random_pet" "uai_name" {
  prefix = "uai-kv"
  length = 2
}

resource "azurerm_user_assigned_identity" "main" {
  name                = random_pet.uai_name.id
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
}

resource "azurerm_federated_identity_credential" "main" {
  name                = "aks-kv"
  resource_group_name = data.azurerm_resource_group.main.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.main.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.main.id
  subject             = "system:serviceaccount:${var.kubernetes_namespace_name}:${var.kubernetes_service_account_name}"

  depends_on = [
    kubernetes_service_account.main,
    data.azurerm_kubernetes_cluster.main
  ]
}

# Need a delay because federated identity credentials shouldn't be used right after creation (must wait a few seconds)
resource "time_sleep" "federated_identity_credential" {
  depends_on = [azurerm_federated_identity_credential.main]
  create_duration = "30s"
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = data.azurerm_key_vault.main.id
  object_id = azurerm_user_assigned_identity.main.principal_id
  tenant_id = azurerm_user_assigned_identity.main.tenant_id
  
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
