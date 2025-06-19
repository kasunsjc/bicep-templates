@description('The name of the virtual network')
param vnetName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Array of address prefixes for the VNet')
param addressPrefixes array

@description('Array of subnet objects')
param subnets array = []

@description('Optional custom DNS servers')
param dnsServers array = []

@description('Resource tags')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        networkSecurityGroup: contains(subnet, 'networkSecurityGroup') ? subnet.networkSecurityGroup : null
        routeTable: contains(subnet, 'routeTable') ? subnet.routeTable : null
        serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : null
        delegations: contains(subnet, 'delegations') ? subnet.delegations : null
        natGateway: contains(subnet, 'natGateway') ? subnet.natGateway : null
        privateEndpointNetworkPolicies: contains(subnet, 'privateEndpointNetworkPolicies') ? subnet.privateEndpointNetworkPolicies : null
        privateLinkServiceNetworkPolicies: contains(subnet, 'privateLinkServiceNetworkPolicies') ? subnet.privateLinkServiceNetworkPolicies : null
      }
    }]
    dhcpOptions: !empty(dnsServers) ? {
      dnsServers: dnsServers
    } : null
  }
}

@description('The resource ID of the virtual network')
output vnetId string = vnet.id

@description('The name of the virtual network')
output vnetName string = vnet.name

@description('Array of subnet information')
output subnets array = [for (subnet, i) in subnets: {
  name: vnet.properties.subnets[i].name
  id: vnet.properties.subnets[i].id
  addressPrefix: vnet.properties.subnets[i].properties.addressPrefix
}]
