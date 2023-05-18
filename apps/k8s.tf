locals {
  secret_provider_class_name = "azure-csi-prov-kv"
  secret_provider_class_name2 = "azure-csi-prov-kv2"
  deployment_name = "key-vault-client"
}

data "azurerm_client_config" "current" {}

resource "kubernetes_service_account" "main" {
  metadata {
    name      = var.kubernetes_service_account_name
    namespace = kubernetes_namespace.main.id
    annotations = {
      "azure.workload.identity/client-id" = azuread_service_principal.main.application_id
    }
    labels = {
      "azure.workload.identity/use" : "true"
    }
  }
}

resource "kubernetes_namespace" "main" {
  metadata {
    annotations = {
      name = var.kubernetes_namespace_name
    }

    name = var.kubernetes_namespace_name
  }
}


resource "kubernetes_manifest" "secret_provider_class" {
  depends_on = [
    time_sleep.federated_identity_credential,
    data.azurerm_kubernetes_cluster.main
  ]

  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      namespace = kubernetes_namespace.main.id
      name = local.secret_provider_class_name
    }

    spec = {
      provider = "azure"
      parameters = {
        tenantID = data.azurerm_client_config.current.tenant_id
        clientID = azuread_service_principal.main.application_id
        keyvaultName = var.key_vault_name
        objects = <<EOF
          array:
            - |
              objectName: ${var.secret_name}
              objectType: secret
        EOF
      }
    }
  }
}

resource "kubernetes_manifest" "secret_provider_class2" {
  depends_on = [
    time_sleep.federated_identity_credential,
    data.azurerm_kubernetes_cluster.main
  ]

  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      namespace = kubernetes_namespace.main.id
      name = local.secret_provider_class_name2
    }

    spec = {
      provider = "azure"
      parameters = {
        tenantID = var.tenant_id2
        clientID = azuread_service_principal.secondary.application_id
        keyvaultName = var.key_vault_name2
        objects = <<EOF
          array:
            - |
              objectName: ${var.secret_name2}
              objectType: secret
        EOF
      }
    }
  }
}

resource "kubernetes_deployment" "main" {
  depends_on = [
    time_sleep.federated_identity_credential,
    # time_sleep.federated_identity_credential2
  ]

  metadata {
    name = local.deployment_name
    labels = {
      "app" = "nginx"
      "azure.workload.identity/use" = "true"
    }
    namespace = kubernetes_namespace.main.id
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.main.metadata[0].name
        container {
          name = "main"
          image = "nginx:latest"
          image_pull_policy = "Always"
          volume_mount {
            mount_path = "mnt/secrets-store"
            name = "secrets-mount"
            read_only = true
          }
          volume_mount {
            mount_path = "mnt/secrets-store2"
            name = "secrets-mount2"
            read_only = true
          }
        }
        volume {
          name = "secrets-mount"
          csi {
            driver = "secrets-store.csi.k8s.io"
            read_only = true
            volume_attributes = {
              secretProviderClass = local.secret_provider_class_name
            }
          }
        }
        volume {
          name = "secrets-mount2"
          csi {
            driver = "secrets-store.csi.k8s.io"
            read_only = true
            volume_attributes = {
              secretProviderClass = local.secret_provider_class_name2
            }
          }
        }
      }
    }
  }
}
