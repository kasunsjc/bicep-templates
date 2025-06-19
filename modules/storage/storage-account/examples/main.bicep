/*
  Example deployment using the Storage Account module
*/

targetScope = 'resourceGroup'

// Parameters
param location string = resourceGroup().location
param environmentName string = 'dev'

// Generate a unique storage account name
var uniqueStorageName = '${environmentName}storage${uniqueString(resourceGroup().id)}'

// Deploy Storage Account using the module
module storageModule '../main.bicep' = {
  name: 'storage-deployment'
  params: {
    storageAccountName: uniqueStorageName
    location: location
    storageAccountSku: 'Standard_GRS'
    allowBlobPublicAccess: false
    tags: {
      Environment: environmentName
      DeployedBy: 'Bicep'
    }
  }
}

// Deploy Storage Account with more advanced configuration
module advancedStorageModule '../main.bicep' = {
  name: 'advanced-storage-deployment'
  params: {
    storageAccountName: '${environmentName}advstorage${uniqueString(resourceGroup().id)}'
    location: location
    storageAccountKind: 'StorageV2'
    storageAccountSku: 'Standard_ZRS'
    accessTier: 'Cool'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: [
        {
          value: '40.112.0.0/16'
          action: 'Allow'
        }
      ]
    }
    tags: {
      Environment: environmentName
      DeployedBy: 'Bicep'
      SecurityLevel: 'High'
    }
  }
}

// Outputs
output storageAccountId string = storageModule.outputs.id
output storageAccountName string = storageModule.outputs.name
output storageAccountBlobEndpoint string = storageModule.outputs.primaryEndpoints.blob
