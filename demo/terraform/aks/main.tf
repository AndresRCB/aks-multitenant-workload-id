resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "main" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_pet" "acr_name" {
  length    = 2
  separator = ""
}

resource "azurerm_container_registry" "main" {
  name                = "${random_pet.acr_name.id}mtdemo"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = azurerm_resource_group.main.location
  name                = "id-aks"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
}

resource "azurerm_user_assigned_identity" "aks_nodes" {
  location            = azurerm_resource_group.main.location
  name                = "aks-nodes"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "aks_nodes_id_operator" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  scope                = azurerm_user_assigned_identity.aks_nodes.id
  role_definition_name = "Managed Identity Operator"
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_user_assigned_identity.aks_nodes.principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "main" {
  location                      = azurerm_resource_group.main.location
  name                          = var.cluster_name
  resource_group_name           = azurerm_resource_group.main.name
  dns_prefix                    = var.cluster_dns_prefix
  oidc_issuer_enabled           = true
  private_cluster_enabled       = false
  public_network_access_enabled = true
  sku_tier                      = var.cluster_sku_tier
  workload_identity_enabled     = true

  default_node_pool {
    name           = "default"
    vm_size        = var.default_node_pool_vm_size
    node_count     = var.cluster_node_count
    vnet_subnet_id = azurerm_subnet.main.id
  }

  api_server_access_profile {
    # Allow the current client's public IP address only
    authorized_ip_ranges = var.authorized_ip_cidr_range == "" ? ["${chomp(data.http.myip.response_body)}/32"] : [var.authorized_ip_cidr_range]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  kubelet_identity {
    client_id = azurerm_user_assigned_identity.aks_nodes.client_id
    object_id = azurerm_user_assigned_identity.aks_nodes.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_nodes.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.cluster_dns_service_ip_address
    service_cidr   = var.cluster_service_ip_range
  }

  depends_on = [
    azurerm_role_assignment.aks_network_contributor,
    azurerm_role_assignment.acr_pull
  ]
}
