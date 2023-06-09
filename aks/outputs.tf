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
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.public_aks_cluster.name}"
  description = "Command to get the cluster's credentials with az cli"
}

output "cluster_id" {
  value       = module.public_aks_cluster.id
  description = "ID of the created kubernetes cluster"
}

output "cluster_invoke_command" {
  value       = module.public_aks_cluster.invoke_command
  description = "Sample command to execute k8s commands on the cluster using az cli"
}

output "cluster_name" {
  value       = module.public_aks_cluster.name
  description = "Name of the kubernetes cluster created by this module"
}