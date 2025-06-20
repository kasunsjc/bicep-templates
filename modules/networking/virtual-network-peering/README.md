# Virtual Network Peering Module

This module creates a peering connection between two Azure virtual networks.

## Parameters

| Parameter Name | Type | Default Value | Description |
|---------------|------|---------------|-------------|
| peeringName | string | | Name of the peering connection |
| localVnetId | string | | ID of the local virtual network |
| remoteVnetId | string | | ID of the remote virtual network |
| allowVirtualNetworkAccess | bool | true | Allow virtual network access from the local virtual network to the remote virtual network |
| allowForwardedTraffic | bool | true | Allow forwarded traffic from the local virtual network to the remote virtual network |
| allowGatewayTransit | bool | false | Allow gateway transit from the local virtual network to the remote virtual network |
| useRemoteGateways | bool | false | Use the gateway in remote virtual network for the local virtual network |

## Outputs

| Output Name | Type | Description |
|------------|------|-------------|
| peeringId | string | The resource ID of the virtual network peering |
| peeringName | string | The name of the virtual network peering |

## Usage

```bicep
module vnetPeering 'path/to/virtual-network-peering/main.bicep' = {
  name: 'hub-to-spoke1-peering'
  params: {
    peeringName: 'hub-to-spoke1'
    localVnetId: hubVnet.id
    remoteVnetId: spoke1Vnet.id
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
  }
}
```
