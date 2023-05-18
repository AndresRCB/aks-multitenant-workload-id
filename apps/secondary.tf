data "azurerm_resource_group" "secondary" {
  provider = azurerm.secondary
  name = var.resource_group_name2
}

data "azurerm_key_vault" "secondary" {
  provider            = azurerm.secondary
  name                = var.key_vault_name2
  resource_group_name = data.azurerm_resource_group.secondary.name
}

resource "azuread_service_principal" "secondary" {
  provider = azuread.secondary
  application_id = azuread_application.main.application_id
}

# resource "azuread_application_federated_identity_credential" "secondary" {
#   provider = azuread.secondary
#   application_object_id = azuread_service_principal.secondary.object_id
#   display_name          = "aks-kv"
#   audiences             = ["api://AzureADTokenExchange"]
#   issuer                = data.azurerm_kubernetes_cluster.main.oidc_issuer_url
#   subject               = "system:serviceaccount:${var.kubernetes_namespace_name}:${var.kubernetes_service_account_name}"

#   depends_on = [
#     kubernetes_service_account.main,
#     data.azurerm_kubernetes_cluster.main
#   ]
# }

# Need a delay because federated identity credentials shouldn't be used right after creation (must wait a few seconds)
# resource "time_sleep" "federated_identity_credential2" {
#   depends_on = [azuread_application_federated_identity_credential.secondary]
#   create_duration = "30s"
# }

resource "azurerm_key_vault_access_policy" "secondary" {
  provider = azurerm.secondary
  key_vault_id = data.azurerm_key_vault.secondary.id
  object_id = azuread_service_principal.secondary.object_id
  tenant_id = var.tenant_id2
  
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
