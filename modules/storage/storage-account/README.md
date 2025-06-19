# Storage Account Module

This module deploys an Azure Storage Account with configurable settings for blob, file, table, and queue services.

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| storageAccountName | string | | Storage Account Name |
| location | string | resourceGroup().location | Location for all resources |
| storageAccountKind | string | 'StorageV2' | Storage Account Kind |
| storageAccountSku | string | 'Standard_LRS' | Storage Account SKU |
| isHnsEnabled | bool | false | Enable hierarchical namespace |
| accessTier | string | 'Hot' | Storage Account access tier |
| allowBlobPublicAccess | bool | false | Allow or disallow public access to blobs |
| minimumTlsVersion | string | 'TLS1_2' | Minimum TLS version |
| enableBlobServiceEncryption | bool | true | Enable blob service encryption |
| enableFileServiceEncryption | bool | true | Enable file service encryption |
| networkAcls | object | {} | Network rule set |
| tags | object | {} | Resource tags |

## Outputs

| Output Name | Type | Description |
|-------------|------|-------------|
| id | string | The resource ID of the storage account |
| name | string | The name of the storage account |
| primaryEndpoints | object | The primary endpoints of the storage account |

## Example Usage

```bicep
module storageAccount 'modules/storage/storage-account/main.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    storageAccountName: 'mystorageaccount'
    storageAccountSku: 'Standard_GRS'
    allowBlobPublicAccess: false
    tags: {
      Environment: 'Production'
      Department: 'IT'
    }
  }
}
```
