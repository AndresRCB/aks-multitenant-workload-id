# AKS Multitenant with Workload Identity Sample
Sample of how to use AKS Workload Identity across multiple AAD tenants

## Prerequisites
- Two [Azure Active Directory](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis) tenants (**not B2C tenants**)
- [Subscriptions and Azure CLI](https://azure.microsoft.com/en-us/get-started/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

## Creating infrastructure
A few variables might be required and not provided by default in these modules. To avoid having to pass the value every time, simple create a terraform.tfvars file in each module that requires these variables. The main one is this:
- keyvault/terraform.tfvars: `key_vault_name = "akswi-andresco-testkv"`

Then, run the following command:
```sh
terragrunt run-all apply --auto-approve
```

## Testing Workload Identity Access

First, get the credentials to the cluster in your machine:
```sh
cd aks
$(terragrunt output -raw cluster_credentials_command)
cd ..
```
Now run a command that should print the value of the key vault secret to console (if it does, this means that the k8s service account can access keyvault using Workload Identity). The default value for that secret is `AKSWIandKeyVaultIntegrated!`.
```sh
cd apps
$(terragrunt output -raw print_key_vault_secret_command)
cd ..
```
