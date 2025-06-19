# Web Application with Storage and Key Vault Example

This example demonstrates how to use multiple Bicep modules together to create a complete infrastructure for a web application.

## Resources Deployed

- **Virtual Network** with subnets for web and data tiers
- **Storage Account** with network security configuration
- **Key Vault** for secrets management with RBAC authorization

## Architecture

This deployment creates a secure architecture with:

1. A virtual network with separate subnets for web and data tiers
2. A storage account with virtual network integration (no public access)
3. A key vault with RBAC authorization and network security rules

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| location | string | resourceGroup().location | Azure region |
| baseName | string | 'webapp' | Base name used for all resources |
| environment | string | 'dev' | Environment name (dev, test, prod) |

## Usage

```bash
# Create a resource group
az group create --name rg-webapp-example --location eastus

# Deploy the example
az deployment group create \
  --resource-group rg-webapp-example \
  --template-file main.bicep \
  --parameters baseName=myapp environment=dev
```

## Next Steps

After deployment, you could:

1. Deploy an App Service into the web subnet
2. Store connection strings as secrets in the Key Vault
3. Configure Managed Identity for the App Service to access Key Vault secrets

## Security Considerations

- Virtual network integration protects both storage and key vault
- Key Vault uses RBAC for more granular access control
- All resources have public access disabled or restricted
