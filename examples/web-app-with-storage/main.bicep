/*
  Example: Web Application with Storage and Key Vault
  
  This example demonstrates how to use multiple modules together to create
  a complete infrastructure for a web application with:
  - Virtual Network with subnets
  - Storage Account for file storage
  - Key Vault for secrets management
*/

targetScope = 'resourceGroup'

// Parameters
param location string = resourceGroup().location
param baseName string = 'webapp'
param environment string = 'dev'

// Variables
var tags = {
  Environment: environment
  Application: baseName
  DeployedBy: 'Bicep'
  CreatedOn: '${utcNow('yyyy-MM-dd')}'
}

// Create a unique suffix based on resource group ID
var uniqueSuffix = uniqueString(resourceGroup().id)

// 1. Deploy Virtual Network 
module vnetModule '../modules/networking/virtual-network/main.bicep' = {
  name: 'vnet-deployment'
  params: {
    vnetName: '${baseName}-${environment}-vnet'
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'web'
        addressPrefix: '10.0.1.0/24'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.KeyVault'
          }
        ]
      }
      {
        name: 'data'
        addressPrefix: '10.0.2.0/24'
      }
    ]
    tags: tags
  }
}

// 2. Deploy Storage Account
module storageModule '../modules/storage/storage-account/main.bicep' = {
  name: 'storage-deployment'
  params: {
    storageAccountName: '${baseName}${environment}${uniqueSuffix}'
    location: location
    storageAccountSku: 'Standard_GRS'
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: '${vnetModule.outputs.vnetId}/subnets/web'
          action: 'Allow'
        }
      ]
    }
    tags: tags
  }
}

// 3. Deploy Key Vault
module keyVaultModule '../modules/security/key-vault/main.bicep' = {
  name: 'keyvault-deployment'
  params: {
    keyVaultName: '${baseName}-${environment}-${uniqueSuffix}-kv'
    location: location
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: '${vnetModule.outputs.vnetId}/subnets/web'
        }
      ]
    }
    tags: tags
  }
}

// Outputs
output vnetId string = vnetModule.outputs.vnetId
output vnetName string = vnetModule.outputs.vnetName
output storageAccountId string = storageModule.outputs.id
output storageAccountName string = storageModule.outputs.name
output storageAccountBlobEndpoint string = storageModule.outputs.primaryEndpoints.blob
output keyVaultId string = keyVaultModule.outputs.keyVaultId
output keyVaultName string = keyVaultModule.outputs.keyVaultName
output keyVaultUri string = keyVaultModule.outputs.keyVaultUri
