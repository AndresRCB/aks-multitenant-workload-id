locals {
  demo_app_pub_image_name = "publisher"
  demo_app_pub_image_tag = "v1.2"
  demo_app_sub_image_name = "subscriber"
  demo_app_sub_image_tag = "v1.0"
  demo_app_ehclient_image_name = "ehclient"
  demo_app_ehclient_image_tag = "v1.0"

  kubernetes_namespace = "aadwi"
  publisher_service_account = "publisher-sa"
  subscriber_service_account = "subscriber-sa"
}