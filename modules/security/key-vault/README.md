# Key Vault Module

This module deploys an Azure Key Vault with configurable access policies.

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| keyVaultName | string | | The name of the Key Vault |
| location | string | resourceGroup().location | Location for all resources |
| sku | string | 'standard' | SKU name for the Key Vault |
| enabledForDeployment | bool | false | Property specifying whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the vault |
| enabledForTemplateDeployment | bool | false | Property specifying whether Azure Resource Manager is permitted to retrieve secrets from the vault |
| enabledForDiskEncryption | bool | false | Property specifying whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys |
| enableRbacAuthorization | bool | false | Property that controls how data actions are authorized |
| enableSoftDelete | bool | true | Property to specify whether the 'soft delete' functionality is enabled for this Key Vault |
| softDeleteRetentionInDays | int | 90 | The number of days to retain deleted vaults and vault objects |
| accessPolicies | array | [] | Array of access policy objects |
| networkAcls | object | {} | Network ACLs for the Key Vault |
| tags | object | {} | Resource tags |

## Outputs

| Output Name | Type | Description |
|-------------|------|-------------|
| keyVaultId | string | The resource ID of the Key Vault |
| keyVaultName | string | The name of the Key Vault |
| keyVaultUri | string | The URI of the Key Vault |

## Example Usage

```bicep
module keyVault 'modules/security/key-vault/main.bicep' = {
  name: 'keyVaultDeployment'
  params: {
    keyVaultName: 'my-key-vault'
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: '00000000-0000-0000-0000-000000000000' // Service Principal ID
        permissions: {
          secrets: [
            'get'
            'list'
          ]
          certificates: [
            'get'
            'list'
          ]
        }
      }
    ]
    tags: {
      Environment: 'Production'
      Department: 'Security'
    }
  }
}
```
