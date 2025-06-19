@description('Storage Account Name')
param storageAccountName string

@description('Location for all resources')
param location string = resourceGroup().location

@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
@description('Storage Account Kind')
param storageAccountKind string = 'StorageV2'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
@description('Storage Account SKU')
param storageAccountSku string = 'Standard_LRS'

@description('Enable hierarchical namespace')
param isHnsEnabled bool = false

@allowed([
  'Hot'
  'Cool'
])
@description('Storage Account access tier')
param accessTier string = 'Hot'

@description('Allow or disallow public access to blobs')
param allowBlobPublicAccess bool = false

@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
@description('Minimum TLS version')
param minimumTlsVersion string = 'TLS1_2'

@description('Enable blob service encryption')
param enableBlobServiceEncryption bool = true

@description('Enable file service encryption')
param enableFileServiceEncryption bool = true

@description('Network rule set')
param networkAcls object = {}

@description('Resource tags')
param tags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: storageAccountKind
  sku: {
    name: storageAccountSku
  }
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: minimumTlsVersion
    isHnsEnabled: isHnsEnabled
    networkAcls: !empty(networkAcls) ? networkAcls : null
    encryption: {
      services: {
        blob: {
          enabled: enableBlobServiceEncryption
        }
        file: {
          enabled: enableFileServiceEncryption
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

@description('The resource ID of the storage account')
output id string = storageAccount.id

@description('The name of the storage account')
output name string = storageAccount.name

@description('The primary endpoints of the storage account')
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
