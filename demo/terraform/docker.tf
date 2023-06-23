resource "null_resource" "mvn_package_demo_app_publisher" {
  provisioner "local-exec" {
    working_dir = "../aks-demo-publisher/"
    command     = "mvn clean package"
  }
}

resource "null_resource" "mvn_package_demo_app_subscriber" {
  provisioner "local-exec" {
    working_dir = "../aks-demo-subscriber/"
    command     = "mvn clean package"
  }
}

resource "null_resource" "mvn_package_demo_app_ehclient" {
  provisioner "local-exec" {
    working_dir = "../aks-demo-ehclient/"
    command     = "mvn clean package"
  }
}

resource "docker_image" "demo_app_publisher" {
  name = "publisher"
  build {
    dockerfile = "../aks-demo-publisher/docker/Dockerfile"
    context    = "../"
    tag        = ["${data.azurerm_container_registry.main.login_server}/${local.demo_app_pub_image_name}:${local.demo_app_pub_image_tag}"]
  }

  depends_on = [
    null_resource.mvn_package_demo_app_publisher
  ]
}

resource "docker_registry_image" "demo_app_publisher" {
  name          = "${data.azurerm_container_registry.main.login_server}/${local.demo_app_pub_image_name}:${local.demo_app_pub_image_tag}"
  keep_remotely = true

  depends_on = [
    docker_image.demo_app_publisher
  ]
}

resource "docker_image" "demo_app_subscriber" {
  name = "subscriber"
  build {
    dockerfile = "../aks-demo-subscriber/docker/Dockerfile"
    context    = "../"
    tag        = ["${data.azurerm_container_registry.main.login_server}/${local.demo_app_sub_image_name}:${local.demo_app_sub_image_tag}"]
  }

  depends_on = [
    null_resource.mvn_package_demo_app_subscriber
  ]
}

resource "docker_registry_image" "demo_app_subscriber" {
  name          = "${data.azurerm_container_registry.main.login_server}/${local.demo_app_sub_image_name}:${local.demo_app_sub_image_tag}"
  keep_remotely = true

  depends_on = [
    docker_image.demo_app_subscriber
  ]
}

resource "docker_image" "demo_app_ehclient" {
  name = "ehclient"
  build {
    dockerfile = "../aks-demo-ehclient/docker/Dockerfile"
    context    = "../"
    tag = ["${data.azurerm_container_registry.main.login_server}/${local.demo_app_ehclient_image_name}:${local.demo_app_ehclient_image_tag}",
    "${data.azurerm_container_registry.main.login_server}/${local.demo_app_ehclient_image_name}:latest"]
  }

  depends_on = [
    null_resource.mvn_package_demo_app_ehclient
  ]
}

resource "docker_registry_image" "demo_app_ehclient" {
  name          = "${data.azurerm_container_registry.main.login_server}/${local.demo_app_ehclient_image_name}:${local.demo_app_ehclient_image_tag}"
  keep_remotely = true

  depends_on = [
    docker_image.demo_app_ehclient
  ]
}
