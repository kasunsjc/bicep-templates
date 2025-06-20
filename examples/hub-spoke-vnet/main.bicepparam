/*
  Hub and Spoke Virtual Network - Parameter file
  
  This parameter file contains values for deploying the hub-spoke architecture.
*/

// Reference to the main Bicep template
using 'main.bicep'

// Location for all resources
param location = 'eastus'

// Hub Virtual Network parameters
param hubVnetName = 'hub-vnet'
param hubVnetAddressPrefix = '10.0.0.0/16'

// Subnet parameters for the hub network
param firewallSubnetPrefix = '10.0.0.0/26'     // AzureFirewallSubnet
param gatewaySubnetPrefix = '10.0.1.0/27'      // GatewaySubnet
param hubManagementSubnetName = 'ManagementSubnet'
param hubManagementSubnetPrefix = '10.0.2.0/24'

// Spoke 1 Virtual Network parameters
param spoke1VnetName = 'spoke1-vnet'
param spoke1VnetAddressPrefix = '10.1.0.0/16'
param spoke1SubnetName = 'ResourceSubnet'
param spoke1SubnetAddressPrefix = '10.1.0.0/24'

// Spoke 2 Virtual Network parameters
param spoke2VnetName = 'spoke2-vnet'
param spoke2VnetAddressPrefix = '10.2.0.0/16'
param spoke2SubnetName = 'ResourceSubnet'
param spoke2SubnetAddressPrefix = '10.2.0.0/24'

// Resource tags
param tags = {
  environment: 'development'
  project: 'hub-spoke-network'
  deployedBy: 'Bicep'
  // Note: While you can't use utcNow() directly in param files, 
  // you can use string interpolation for many dynamic values
}
