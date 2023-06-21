resource "kubernetes_namespace" "main" {
  metadata {
    annotations = {
      name = local.kubernetes_namespace
    }
    name =  local.kubernetes_namespace
  }
}

resource "kubernetes_service_account" "publisher" {

  metadata {
    name      = local.publisher_service_account
    namespace = kubernetes_namespace.main.id
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.main-publisher.client_id
    }
    labels = {
      "azure.workload.identity/use" : "true"
    }
  }
}

resource "kubernetes_service_account" "subscriber" {

  metadata {
    name      = local.subscriber_service_account
    namespace = kubernetes_namespace.main.id
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.main-subscriber.client_id
    }
    labels = {
      "azure.workload.identity/use" : "true"
    }
  }
}

resource "azurerm_federated_identity_credential" "publisher" {

  name                = "publisher-fed"
  resource_group_name = data.azurerm_resource_group.primary.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.main-publisher.id
  subject             = "system:serviceaccount:${kubernetes_namespace.main.id}:${kubernetes_service_account.publisher.metadata[0].name}"

  depends_on = [
    kubernetes_service_account.publisher,
    module.aks,
    module.secondary-setup
  ]
}

resource "azurerm_federated_identity_credential" "subscriber" {

  name                = "subscriber-fed"
  resource_group_name = data.azurerm_resource_group.primary.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.main-subscriber.id
  subject             = "system:serviceaccount:${kubernetes_namespace.main.id}:${kubernetes_service_account.subscriber.metadata[0].name}"

  depends_on = [
    kubernetes_service_account.subscriber,
    module.aks,
    module.secondary-setup
  ]
}

resource "azurerm_federated_identity_credential" "sec" {
  provider = azurerm.second

  name                = "secondary-pubsub-fed"
  resource_group_name = data.azurerm_resource_group.secondary.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.secondary.id
  subject             = "system:serviceaccount:${kubernetes_namespace.main.id}:${kubernetes_service_account.publisher.metadata[0].name}"

  depends_on = [
    kubernetes_service_account.publisher,
    module.aks,
    module.secondary-setup
  ]
}

resource "time_sleep" "federated_identity_credential" {
  depends_on = [azurerm_federated_identity_credential.publisher, azurerm_federated_identity_credential.sec, azurerm_federated_identity_credential.subscriber]
  create_duration = "20s"
}
