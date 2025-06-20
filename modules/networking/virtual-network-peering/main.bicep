/*
  Virtual Network Peering Module
  
  This module creates a peering connection between two virtual networks.
*/

@description('Name of the peering connection')
param peeringName string

@description('ID of the local virtual network')
param localVnetId string

@description('ID of the remote virtual network')
param remoteVnetId string

@description('Allow virtual network access from the local virtual network to the remote virtual network')
param allowVirtualNetworkAccess bool = true

@description('Allow forwarded traffic from the local virtual network to the remote virtual network')
param allowForwardedTraffic bool = true

@description('Allow gateway transit from the local virtual network to the remote virtual network')
param allowGatewayTransit bool = false

@description('Use the gateway in remote virtual network for the local virtual network')
param useRemoteGateways bool = false

// Extract VNet name from the resource ID
var localVnetName = last(split(localVnetId, '/'))

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = {
  name: '${localVnetName}/${peeringName}'
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}

output peeringId string = vnetPeering.id
output peeringResourceName string = vnetPeering.name


