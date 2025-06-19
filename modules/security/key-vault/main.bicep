@description('The name of the Key Vault')
param keyVaultName string

@description('Location for all resources')
param location string = resourceGroup().location

@allowed([
  'standard'
  'premium'
])
@description('SKU name for the Key Vault')
param sku string = 'standard'

@description('Property specifying whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the vault')
param enabledForDeployment bool = false

@description('Property specifying whether Azure Resource Manager is permitted to retrieve secrets from the vault')
param enabledForTemplateDeployment bool = false

@description('Property specifying whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys')
param enabledForDiskEncryption bool = false

@description('Property that controls how data actions are authorized')
param enableRbacAuthorization bool = false

@description('Property to specify whether the "soft delete" functionality is enabled for this Key Vault')
param enableSoftDelete bool = true

@description('The number of days to retain deleted vaults and vault objects')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

@description('Array of access policy objects')
param accessPolicies array = []

@description('Network ACLs for the Key Vault')
param networkAcls object = {}

@description('Resource tags')
param tags object = {}

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableRbacAuthorization: enableRbacAuthorization
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    sku: {
      family: 'A'
      name: sku
    }
    accessPolicies: accessPolicies
    networkAcls: !empty(networkAcls) ? networkAcls : null
  }
}

@description('The resource ID of the Key Vault')
output keyVaultId string = keyVault.id

@description('The name of the Key Vault')
output keyVaultName string = keyVault.name

@description('The URI of the Key Vault')
output keyVaultUri string = keyVault.properties.vaultUri
