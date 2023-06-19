locals {
  demo_app_pub_image_name = "publisher"
  demo_app_pub_image_tag = "v1.2"
  demo_app_sub_image_name = "subscriber"
  demo_app_sub_image_tag = "v1.1"
  kubernetes_namespace = "aadwi"
  publisher_service_account = "aks-publisher-ten1-sa"
  subscriber_service_account = "aks-subscriber-ten1-sa"
  secondary_service_account = "aks-ten2-sa"

  workload_identity = [
    {
      uami_id         = azurerm_user_assigned_identity.main-publisher.id
      uami_client_id  = azurerm_user_assigned_identity.main-publisher.client_id
      service_account = local.publisher_service_account
    },
    {
      uami_id         = azurerm_user_assigned_identity.main-subscriber.id
      uami_client_id  = azurerm_user_assigned_identity.main-subscriber.client_id
      service_account = local.subscriber_service_account
    }
  ]
  primary_sa = { for sa in local.workload_identity : sa.service_account => sa }
  primary_wi = { for wa in local.workload_identity : wa.service_account => wa }
}