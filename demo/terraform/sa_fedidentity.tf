resource "kubernetes_namespace" "main" {
  metadata {
    annotations = {
      name = local.kubernetes_namespace
    }
    name =  local.kubernetes_namespace
  }
}

resource "kubernetes_service_account" "primary" {
  for_each = local.primary_sa

  metadata {
    name      = each.key
    namespace = kubernetes_namespace.main.id
    annotations = {
      "azure.workload.identity/client-id" = each.value.uami_client_id
      "azure.workload.identity/tenant-id" = data.azurerm_client_config.current.tenant_id
    }
    labels = {
      "azure.workload.identity/use" : "true"
    }
  }
}

resource "kubernetes_service_account" "secondary" {
  metadata {
    name      = local.secondary_service_account
    namespace = kubernetes_namespace.main.id
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.secondary.client_id
      "azure.workload.identity/tenant-id" = module.secondary-setup.tenant_id
    }
    labels = {
      "azure.workload.identity/use" : "true"
    }
  }
}

resource "azurerm_federated_identity_credential" "primary" {
  for_each = local.primary_wi

  name                = "${each.key}-fid"
  resource_group_name = data.azurerm_resource_group.primary.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = each.value.uami_id
  subject             = "system:serviceaccount:${kubernetes_service_account.primary[each.key].metadata[0].namespace}:${kubernetes_service_account.primary[each.key].metadata[0].name}"

  depends_on = [
    kubernetes_service_account.primary,
    module.aks,
    module.secondary-setup
  ]
}

resource "azurerm_federated_identity_credential" "secondary" {
  provider = azurerm.second

  name                = "secondary-fid"
  resource_group_name = data.azurerm_resource_group.secondary.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.secondary.id
  # TODO what is the service account(out of 2 in primary tenant) to use here?
  subject             = "system:serviceaccount:${kubernetes_namespace.main.id}:${local.secondary_service_account}"

  depends_on = [
    kubernetes_service_account.primary,
    module.aks,
    module.secondary-setup
  ]
}

# Need a delay because federated identity credentials shouldn't be used right after creation (must wait a few seconds)
resource "time_sleep" "federated_identity_credential" {
  depends_on = [azurerm_federated_identity_credential.primary]
  create_duration = "20s"
}

# Need a delay because federated identity credentials shouldn't be used right after creation (must wait a few seconds)
resource "time_sleep" "federated_identity_credential2" {
  depends_on = [azurerm_federated_identity_credential.secondary]
  create_duration = "20s"
}

