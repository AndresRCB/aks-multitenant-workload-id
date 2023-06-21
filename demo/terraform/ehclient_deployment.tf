resource "kubernetes_deployment" "ehclient" {
  metadata {
    name      = "ehclient"
    labels    = {
      app                           = "ehclient"
      "azure.workload.identity/use" = "true"
    }
    namespace = kubernetes_namespace.main.id
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ehclient"
      }
    }
    template {
      metadata {
        labels = {
          app = "ehclient"
         "azure.workload.identity/use" = "true"
        }
      }

      spec {
       service_account_name = kubernetes_service_account.publisher.metadata[0].name
        container {
          image             = "${data.azurerm_container_registry.main.login_server}/${local.demo_app_ehclient_image_name}:${local.demo_app_ehclient_image_tag}"
          name              = local.demo_app_ehclient_image_name
          image_pull_policy = "Always"

          env {
            name  = "ehNamespaceOfTenant2"
            value = "${azurerm_eventhub_namespace.eventhubs_namespace_secondary.name}.servicebus.windows.net"
          }
          env {
            name  = "ehNameOfTenant2"
            value = azurerm_eventhub.eventhubs_secondary.name
          }
          env {
            name  = "clientId2"
            value = azurerm_user_assigned_identity.secondary.client_id
          }
          env {
            name  = "tenantId2"
            value = module.secondary-setup.tenant_id
          }
        }
      }
    }
  }

  depends_on = [
    docker_registry_image.demo_app_ehclient,time_sleep.federated_identity_credential
  ]
}

