/*
  Hub and Spoke Virtual Network Architecture
  
  This template deploys a hub and spoke virtual network architecture with:
  - One hub virtual network
  - Two spoke virtual networks
  - Network peering between hub and each spoke
  - Direct peering between spokes (as shown in the diagram)
*/

targetScope = 'resourceGroup'

// Parameters
param location string = resourceGroup().location
param hubVnetName string = 'hub-vnet'
param hubVnetAddressPrefix string = '10.0.0.0/16'
param hubSubnetName string = 'AzureFirewallSubnet' // Name required for Azure Firewall subnet
param hubSubnetAddressPrefix string = '10.0.0.0/24'

param spoke1VnetName string = 'spoke1-vnet'
param spoke1VnetAddressPrefix string = '10.1.0.0/16'
param spoke1SubnetName string = 'ResourceSubnet'
param spoke1SubnetAddressPrefix string = '10.1.0.0/24'

param spoke2VnetName string = 'spoke2-vnet'
param spoke2VnetAddressPrefix string = '10.2.0.0/16'
param spoke2SubnetName string = 'ResourceSubnet'
param spoke2SubnetAddressPrefix string = '10.2.0.0/24'

param tags object = {
  environment: 'production'
  project: 'hub-spoke-network'
}

// Deploy the hub virtual network
module hubVnet '../../modules/networking/virtual-network/main.bicep' = {
  name: 'hubVnetDeployment'
  params: {
    vnetName: hubVnetName
    location: location
    addressPrefixes: [
      hubVnetAddressPrefix
    ]
    subnets: [
      {
        name: hubSubnetName
        addressPrefix: hubSubnetAddressPrefix
      }
    ]
    tags: tags
  }
}

// Deploy spoke 1 virtual network
module spoke1Vnet '../../modules/networking/virtual-network/main.bicep' = {
  name: 'spoke1VnetDeployment'
  params: {
    vnetName: spoke1VnetName
    location: location
    addressPrefixes: [
      spoke1VnetAddressPrefix
    ]
    subnets: [
      {
        name: spoke1SubnetName
        addressPrefix: spoke1SubnetAddressPrefix
      }
    ]
    tags: tags
  }
}

// Deploy spoke 2 virtual network
module spoke2Vnet '../../modules/networking/virtual-network/main.bicep' = {
  name: 'spoke2VnetDeployment'
  params: {
    vnetName: spoke2VnetName
    location: location
    addressPrefixes: [
      spoke2VnetAddressPrefix
    ]
    subnets: [
      {
        name: spoke2SubnetName
        addressPrefix: spoke2SubnetAddressPrefix
      }
    ]
    tags: tags
  }
}

// Create peering from hub to spoke 1
module hubToSpoke1Peering '../../modules/networking/virtual-network-peering/main.bicep' = {
  name: 'hubToSpoke1Peering'
  params: {
    peeringName: 'hub-to-spoke1'
    localVnetId: hubVnet.outputs.vnetId
    remoteVnetId: spoke1Vnet.outputs.vnetId
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    allowGatewayTransit: true
  }
}

// Create peering from spoke 1 to hub
module spoke1ToHubPeering '../../modules/networking/virtual-network-peering/main.bicep' = {
  name: 'spoke1ToHubPeering'
  params: {
    peeringName: 'spoke1-to-hub'
    localVnetId: spoke1Vnet.outputs.vnetId
    remoteVnetId: hubVnet.outputs.vnetId
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
  }
}

// Create peering from hub to spoke 2
module hubToSpoke2Peering '../../modules/networking/virtual-network-peering/main.bicep' = {
  name: 'hubToSpoke2Peering'
  params: {
    peeringName: 'hub-to-spoke2'
    localVnetId: hubVnet.outputs.vnetId
    remoteVnetId: spoke2Vnet.outputs.vnetId
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    allowGatewayTransit: true
  }
}

// Create peering from spoke 2 to hub
module spoke2ToHubPeering '../../modules/networking/virtual-network-peering/main.bicep' = {
  name: 'spoke2ToHubPeering'
  params: {
    peeringName: 'spoke2-to-hub'
    localVnetId: spoke2Vnet.outputs.vnetId
    remoteVnetId: hubVnet.outputs.vnetId
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
  }
}

// Create direct peering between spokes (as shown in the diagram)
module spoke1ToSpoke2Peering '../../modules/networking/virtual-network-peering/main.bicep' = {
  name: 'spoke1ToSpoke2Peering'
  params: {
    peeringName: 'spoke1-to-spoke2'
    localVnetId: spoke1Vnet.outputs.vnetId
    remoteVnetId: spoke2Vnet.outputs.vnetId
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
  }
}

module spoke2ToSpoke1Peering '../../modules/networking/virtual-network-peering/main.bicep' = {
  name: 'spoke2ToSpoke1Peering'
  params: {
    peeringName: 'spoke2-to-spoke1'
    localVnetId: spoke2Vnet.outputs.vnetId
    remoteVnetId: spoke1Vnet.outputs.vnetId
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
  }
}

// Outputs
output hubVnetId string = hubVnet.outputs.vnetId
output hubVnetName string = hubVnet.outputs.vnetName
output spoke1VnetId string = spoke1Vnet.outputs.vnetId
output spoke1VnetName string = spoke1Vnet.outputs.vnetName
output spoke2VnetId string = spoke2Vnet.outputs.vnetId
output spoke2VnetName string = spoke2Vnet.outputs.vnetName
