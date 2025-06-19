/*
  Example deployment using the Virtual Network module
*/

targetScope = 'resourceGroup'

// Parameters
param location string = resourceGroup().location
param environmentName string = 'dev'

// Network Security Group for the default subnet
resource defaultNsg 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: 'default-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPS'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Deploy Virtual Network using the module
module vnetModule '../main.bicep' = {
  name: 'vnet-deployment'
  params: {
    vnetName: '${environmentName}-vnet'
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroup: {
          id: defaultNsg.id
        }
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: '10.0.1.0/24'
      }
      {
        name: 'AppSubnet'
        addressPrefix: '10.0.2.0/24'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.KeyVault'
          }
        ]
      }
    ]
    tags: {
      Environment: environmentName
      DeployedBy: 'Bicep'
    }
  }
}

// Outputs
output vnetId string = vnetModule.outputs.vnetId
output vnetName string = vnetModule.outputs.vnetName
output subnets array = vnetModule.outputs.subnets
