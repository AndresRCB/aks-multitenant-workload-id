resource "kubernetes_deployment" "publisher" {
  metadata {
    name      = "publisher"
    labels    = {
      app                           = "publisher"
      "azure.workload.identity/use" = "true"
    }
    namespace = kubernetes_namespace.main.id
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "publisher"
      }
    }
    template {
      metadata {
        labels = {
          app = "publisher"
          "azure.workload.identity/use" = "true"
        }
      }

      spec {
        service_account_name = local.publisher_service_account
        container {
          image             = "${data.azurerm_container_registry.main.login_server}/${local.demo_app_pub_image_name}:${local.demo_app_pub_image_tag}"
          name              = local.demo_app_pub_image_name
          image_pull_policy = "Always"
          env {
            name  = "SPRING_CLOUD_STREAM_BINDINGS_PUBLISH1_OUT_0_DESTINATION"
            value = azurerm_eventhub.eventhubs_primary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDINGS_PUBLISH2_OUT_0_DESTINATION"
            value = azurerm_eventhub.eventhubs_secondary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_NAMESPACE"
            value = azurerm_eventhub_namespace.eventhubs_namespace_primary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_EVENT_HUB_NAME"
            value = azurerm_eventhub.eventhubs_primary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_CREDENTIAL_CLIENT_ID"
            value = azurerm_user_assigned_identity.main-publisher.client_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_ENDPOINT"
            value = "https://${azurerm_storage_account.storage_account_primary.name}.blob.core.windows.net/${azurerm_storage_container.storage_container_primary.name}"
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_CONTAINER_NAME"
            value = azurerm_storage_container.storage_container_primary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_ACCOUNT_NAME"
            value = azurerm_storage_account.storage_account_primary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_CREDENTIAL_CLIENT_ID"
            value = azurerm_user_assigned_identity.main-publisher.client_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_PROFILE_TENANT_ID"
            value = data.azurerm_client_config.current.tenant_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_1_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_CONSUMER_GROUP"
            value = "$Default"
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_NAMESPACE"
            value = azurerm_eventhub_namespace.eventhubs_namespace_secondary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_EVENT_HUB_NAME"
            value = azurerm_eventhub.eventhubs_secondary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_ENDPOINT"
            value = "https://${azurerm_storage_account.storage_account_secondary.name}.blob.core.windows.net/${azurerm_storage_container.storage_container_secondary.name}"
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_CONTAINER_NAME"
            value = azurerm_storage_container.storage_container_secondary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_ACCOUNT_NAME"
            value = azurerm_storage_account.storage_account_secondary.name
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_CREDENTIAL_CLIENT_ID"
            value = azurerm_user_assigned_identity.secondary.client_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_PROFILE_TENANT_ID"
            value = module.secondary-setup.tenant_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_CONSUMER_GROUP"
            value = "$Default"
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PROFILE_TENANT_ID"
            value = module.secondary-setup.tenant_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_PRODUCER_PROFILE_TENANT_ID"
            value = module.secondary-setup.tenant_id
          }
          env {
            name  = "SPRING_CLOUD_STREAM_BINDERS_EVENTHUB_2_ENVIRONMENT_SPRING_CLOUD_AZURE_EVENTHUBS_CREDENTIAL_CLIENT_ID"
            value = azurerm_user_assigned_identity.secondary.client_id
          }
          env {
            name = "spring_profiles_active"
            value = "dev"
          }
          env {
            name = "LOGGING_LEVEL_COM_AZURE_IDENTITY_DEFAULTAZURECREDENTIAL"
            value = "DEBUG"
          }
          env {
            name = "LOGGING_LEVEL_COM_AZURE_IDENTITY"
            value = "DEBUG"
          }
        }
      }
    }
  }

  depends_on = [
    docker_registry_image.demo_app_publisher,time_sleep.federated_identity_credential
  ]
}

