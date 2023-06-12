#
#
#resource "kubernetes_deployment" "publisher" {
#  metadata {
#    name      = "publisher"
#    labels    = {
#      app                           = "publisher"
#      "azure.workload.identity/use" = "true"
#    }
#    namespace = var.kubernetes_namespace_id
#  }
#  spec {
#    replicas = 1
#
#    selector {
#      match_labels = {
#        app = "publisher"
#      }
#    }
#    template {
#      metadata {
#        labels = {
#          app = "publisher"
#        }
#      }
#
#      spec {
#        service_account_name = var.kubernetes_service_account_name
#        container {
#          image             = local.demo_app_pub_image_name
#          name              = "publisher"
#          image_pull_policy = "Always"
#        }
#      }
#    }
#  }
#}
#
#resource "kubernetes_deployment" "subscriber" {
#  metadata {
#    name      = "subscriber"
#    labels    = {
#      app                           = "subscriber"
#      "azure.workload.identity/use" = "true"
#    }
#    namespace = var.kubernetes_namespace_id
#  }
#  spec {
#    replicas = 1
#
#    selector {
#      match_labels = {
#        app = "subscriber"
#      }
#    }
#    template {
#      metadata {
#        labels = {
#          app = "subscriber"
#        }
#      }
#
#      spec {
#        service_account_name = var.kubernetes_service_account_name
#        container {
#          image             = local.demo_app_sub_image_name
#          name              = "subscriber"
#          image_pull_policy = "Always"
#        }
#      }
#    }
#  }
#}