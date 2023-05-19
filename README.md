# AKS Multitenant with Workload Identity Sample
Sample of how to use AKS Workload Identity across multiple AAD tenants

## Prerequisites
- Two [Azure Active Directory](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis) tenants (**not B2C tenants**)
- [Subscriptions and Azure CLI](https://azure.microsoft.com/en-us/get-started/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- Make sure that your account has access to both tenants (you would need to be a guest in the second tenant) or that you properly configure both service principals for terraform use (outside the scope of this repo)
    - When running locally, the sample and terraform/terragrunt makes use of the Azure CLI credentials stored. This is enabled by running the following to logon instructions below to both the Primary AAD Tenant, and the Service Provider AAD Tenant (secondary).
- Set your default subscription using `az account set -n SUBSCRIPTION_ID`. We will be using `SUBSCRIPTION_ID2` as secondary subscription.
- Your account principal requires `Application Adminstrator` role in the AAD of the primary tenant in order for the `apps` provisioning to work within the primary Tenant of this example.
- 

## Logging on locally with Azure CLI
Your local user needs some level of access. For the demo a requirement is to be able to create resources in two different tenants and subscriptions. In addition a need to create an Azure AD application in the primary AAD Tenant.

#### login via:
```bash
az login --allow-no-subscriptions --tenant TENANT_1
az login --allow-no-subscriptions --tenant TENANT_2

az account set -s SUBSCRIPTION_ID

#you should see two subs via az cli with the Primary subscription/tenant set as Default.
az account list -o table --all --query "[].{TenantID: tenantId, Subscription: name, Default: isDefault, ID: id}"
```


## Creating infrastructure
A few variables might be required and not provided by default in these modules. To avoid having to pass the value every time, simple create a terraform.tfvars file in each module that requires these variables. The main ones are:
- keyvault/terraform.tfvars:
```sh
key_vault_name = "your-keyvault-name-testkv"
```
- keyvault2/terraform.tfvars:
```sh
subscription_id = "SUBSCRIPTION_ID2"
tenant_id = "TENANT_ID2"
key_vault_name = "your-keyvault-name-testkv2"
```
- apps/terraform.tfvars:
```sh
subscription_id = "SUBSCRIPTION_ID"
tenant_id = "TENANT_ID"
subscription_id2 = "SUBSCRIPTION_ID2"
tenant_id2 = "TENANT_ID2"
```

Then, run the following command:
```sh
terragrunt run-all apply --auto-approve
```

## Azure Active Directory (AAD) and Multitenancy

This sample specifically showcases how to use Azure RBAC to access resources securely across AAD tenants. This is accomplished by creating Federated Identity Credentials in managed identities that map to a workload's kubernetes service account (k8s identity). This enables the workload to identify itself as said managed identities when needed. The two only parameters that the workload needs to use are the UAMI (User Assigned Managed Identity) Client ID and Tenant ID.

In this sample, the workload is able to access Azure Key Vaults across tenants without handling credentials. The setup leverages Terraform (IaC) to create identities, map them to the k8s service account and inject the Client ID and Tenant ID. Said workload can then use one identity to obtain credentials across tenants and access Azure resources safely. The diagram below shows the simple setup created by executing the command `terragrunt run-all apply --auto-approve`.

![Diagram: AKS Workload Loading Secrets from Azure Key Vault Across Tenants](images/MultitenantWorkloadIdentity.svg)


## Testing Workload Identity Access

First, get the credentials to the cluster in your machine:
```sh
cd aks
$(terragrunt output -raw cluster_credentials_command)
cd ..
```
Now run a command that should print the value of the key vault secrets to console (if it does, this means that the k8s service account can access keyvaults across tenants using Workload Identity). The default value for the secrets are `AKSWIandKeyVaultIntegrated!` and `AKSWIandKeyVaultIntegrated 2!`.
```sh
cd apps
$(terragrunt output -raw print_key_vault_secret_command --terragrunt-no-auto-init)
$(terragrunt output -raw print_key_vault_secret_command2 --terragrunt-no-auto-init)
cd ..
```
>NOTE: you can ignore a warning: `WARN[0000] Detected that init is needed, but Auto-Init is disabled.` from the above commands as if all steps followed, the terraform state exists already.

**Enjoy.**  :smile:
