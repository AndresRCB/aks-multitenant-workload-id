data "azurerm_resource_group" "secondary" {
  provider = azurerm.secondary
  name = var.resource_group_name2
}

data "azurerm_key_vault" "secondary" {
  provider            = azurerm.secondary
  name                = var.key_vault_name2
  resource_group_name = data.azurerm_resource_group.secondary.name
}

resource "random_pet" "uai_name2" {
  prefix = "uai-kv"
  length = 2
}

resource "azurerm_user_assigned_identity" "secondary" {
  provider = azurerm.secondary
  name                = random_pet.uai_name.id
  resource_group_name = data.azurerm_resource_group.secondary.name
  location            = data.azurerm_resource_group.secondary.location
}

resource "azurerm_federated_identity_credential" "secondary" {
  provider = azurerm.secondary
  name                = "aks-kv"
  resource_group_name = data.azurerm_resource_group.secondary.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.main.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.secondary.id
  subject             = "system:serviceaccount:${var.kubernetes_namespace_name}:${var.kubernetes_service_account_name}"

  depends_on = [
    kubernetes_service_account.main,
    data.azurerm_kubernetes_cluster.main
  ]
}

# Need a delay because federated identity credentials shouldn't be used right after creation (must wait a few seconds)
resource "time_sleep" "federated_identity_credential2" {
  depends_on = [azurerm_federated_identity_credential.secondary]
  create_duration = "30s"
}

resource "azurerm_key_vault_access_policy" "secondary" {
  provider = azurerm.secondary
  key_vault_id = data.azurerm_key_vault.secondary.id
  object_id = azurerm_user_assigned_identity.secondary.principal_id
  tenant_id = azurerm_user_assigned_identity.secondary.tenant_id
  
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
