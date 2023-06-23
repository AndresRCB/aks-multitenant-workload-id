output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group where all resources for this test will live"
}

output "environment_variable_setup" {
  value       = <<-COMMAND
        export RESOURCE_GROUP=${azurerm_resource_group.main.name}
        COMMAND
  description = "Command to set environment variables"
}

output "cluster_credentials_command" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
  description = "Command to get the cluster's credentials with az cli"
}

output "cluster_id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "ID of the created kubernetes cluster"
}

#output "cluster_invoke_command" {
#  value       = azurerm_kubernetes_cluster.main.invoke_command
#  description = "Sample command to execute k8s commands on the cluster using az cli"
#}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.main.name
  description = "Name of the kubernetes cluster created by this module"
}

output "aks_cluster_uai" {
  value       = azurerm_user_assigned_identity.aks.principal_id
  description = "Aks cluster user assigned identity"
}

output "aks_nodes_uai" {
  value       = azurerm_user_assigned_identity.aks_nodes.principal_id
  description = "Aks cluster nodes user assigned identity"
}

output "acr_name" {
  value       = azurerm_container_registry.main.name
  description = "ACR name"
}

output "acr_id" {
  value       = azurerm_container_registry.main.id
  description = "ACR Id"
}

output "acr_loginserver" {
  value       = azurerm_container_registry.main.login_server
  description = "ACR loginserver"
}

output "oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
  description = "OIDC Issuer URL for the public cluster"
}

output "acr_admin_username" {
  value = azurerm_container_registry.main.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.main.admin_username
}