output "resource_group_name" {
  value       = data.azurerm_resource_group.main.name
  description = "Name of the resource group where all resources for this test will live"
}

output "environment_variable_setup" {
  value       = <<-COMMAND
        export RESOURCE_GROUP=${data.azurerm_resource_group.main.name}
        COMMAND
  description = "Command to set environment variables after this environment is brought up"
}

output "print_key_vault_secret_command" {
  value = "kubectl exec -i deploy/${local.deployment_name} -n ${kubernetes_namespace.main.id} -- cat /mnt/secrets-store/${var.secret_name}"
  description = "Command to print the key vault secret mounted in the kubernetes client deployment (a test)"
}

output "print_key_vault_secret_command2" {
  value = "kubectl exec -i deploy/${local.deployment_name} -n ${kubernetes_namespace.main.id} -- cat /mnt/secrets-store2/${var.secret_name2}"
  description = "Command to print the secondary key vault secret mounted in the kubernetes client deployment (a test)"
}
