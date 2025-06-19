# Virtual Network Module

This module deploys an Azure Virtual Network with configurable address spaces and subnets.

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| vnetName | string | | The name of the virtual network |
| location | string | resourceGroup().location | Location for all resources |
| addressPrefixes | array | | Array of address prefixes for the VNet |
| subnets | array | [] | Array of subnet objects |
| dnsServers | array | [] | Optional custom DNS servers |
| tags | object | {} | Resource tags |

## Outputs

| Output Name | Type | Description |
|-------------|------|-------------|
| vnetId | string | The resource ID of the virtual network |
| vnetName | string | The name of the virtual network |
| subnets | array | Array of subnet information |

## Example Usage

```bicep
module vnet 'modules/networking/virtual-network/main.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: 'my-vnet'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroup: {
          id: nsgId
        }
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    tags: {
      Environment: 'Production'
      Owner: 'Network Team'
    }
  }
}
```
