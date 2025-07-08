# Azure Web App with Key Vault Integration

This Terraform configuration deploys an Azure Web App with Key Vault integration for secure secret management.

## Architecture Overview

This infrastructure creates:
- **Resource Group**: Container for all resources
- **App Service Plan**: Basic tier (B1) hosting plan
- **App Service**: Web application with Key Vault integration
- **Key Vault**: Secure storage for application secrets
- **Key Vault Secret**: Example secret accessible by the web app

## Prerequisites

- Azure CLI installed and authenticated
- Terraform installed (version 0.12+)
- Azure subscription with appropriate permissions
- Storage account for Terraform state (see backend configuration)

## Files Structure

```
├── main.tf          # Main infrastructure resources
├── variables.tf     # Variable definitions and defaults
├── outputs.tf       # Output values
├── provider.tf      # Provider and backend configuration
└── README.md        # This file
```

## Configuration Details

### Resources Created

1. **Resource Group** (`azurerm_resource_group.main`)
   - Location: East US (configurable)
   - Name: example-rg (configurable)

2. **App Service Plan** (`azurerm_app_service_plan.plan`)
   - SKU: Basic B1
   - Location: Same as resource group

3. **App Service** (`azurerm_app_service.webapp`)
   - Integrated with Key Vault for secret access
   - App setting: `SecretFromKV` references Key Vault secret

4. **Key Vault** (`azurerm_key_vault.kv`)
   - Standard SKU
   - Soft delete enabled (7 days retention)
   - Access policy for current service principal

5. **Key Vault Secret** (`azurerm_key_vault_secret.secret`)
   - Example secret with configurable name and value

### Backend Configuration

The configuration uses Azure Storage for remote state:
- Resource Group: `tfstate-rg`
- Storage Account: `yourtfstatestorage`
- Container: `tfstate`
- State File: `prod.terraform.tfstate`

## Usage

### 1. Setup Backend Storage

Create the storage account for Terraform state:

```bash
# Create resource group for state
az group create --name tfstate-rg --location "East US"

# Create storage account (replace with unique name)
az storage account create \
  --resource-group tfstate-rg \
  --name yourtfstatestorage \
  --sku Standard_LRS \
  --encryption-services blob

# Create container
az storage container create \
  --name tfstate \
  --account-name yourtfstatestorage
```

### 2. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### 3. Access Your Resources

After deployment, you can access:
- Web App URL: Available as output `app_service_url`
- Key Vault: Available in Azure Portal
- Secret: Accessible by the web app via Key Vault reference

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `location` | Azure region | East US |
| `resource_group_name` | Resource group name | example-rg |
| `app_service_plan_name` | App service plan name | example-appserviceplan |
| `app_service_name` | Web app name | example-webapp |
| `key_vault_name` | Key vault name | examplekv123 |
| `secret_name` | Secret name in Key Vault | example-secret |
| `secret_value` | Secret value | SuperSecretValue123! |

## Outputs

- `app_service_url`: The default hostname of the deployed web application

## Security Considerations

1. **Key Vault Access**: The current configuration grants access to the service principal running Terraform
2. **Secret Management**: Avoid storing sensitive values in variables.tf in production
3. **Soft Delete**: Key Vault has soft delete enabled for recovery
4. **App Service Integration**: Web app can access secrets via Key Vault references

## Customization

To customize the deployment:

1. **Modify variables**: Update `variables.tf` or use `-var` flags
2. **Change SKU**: Modify the App Service Plan SKU in `main.tf`
3. **Add resources**: Extend `main.tf` with additional Azure resources
4. **Environment-specific**: Create separate `.tfvars` files for different environments

## Example Usage with Custom Values

```bash
terraform apply \
  -var="location=West US 2" \
  -var="resource_group_name=my-prod-rg" \
  -var="app_service_name=my-unique-webapp"
```

## Clean Up

To destroy the infrastructure:

```bash
terraform destroy
```

## Notes

- Key Vault names must be globally unique
- App Service names must be globally unique
- Ensure your Azure account has necessary permissions
- Update the backend storage account name in `provider.tf` before use

## Troubleshooting

1. **Key Vault Access Issues**: Verify your service principal has appropriate permissions
2. **Name Conflicts**: Ensure globally unique names for Key Vault and App Service
3. **Backend Issues**: Verify storage account exists and is accessible
4. **Permission Errors**: Check Azure RBAC permissions for your account/service principal
