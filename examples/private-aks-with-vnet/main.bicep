/*
  Private AKS Cluster with Bring Your Own VNET Example
  
  This example deploys a private AKS cluster in an existing VNet with 
  separate subnets for AKS nodes and private endpoints.
*/

// Parameters
@description('Prefix used for all resources')
param prefix string = 'aks-demo'

@description('Azure region for the deployment')
param location string = resourceGroup().location

@description('Object containing resource tags')
param tags object = {
  environment: 'dev'
  project: 'AKS Demo'
}

// VNet Configuration
@description('VNET address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('AKS subnet address prefix')
param aksSubnetPrefix string = '10.0.0.0/22'

@description('Private endpoints subnet address prefix')
param peSubnetPrefix string = '10.0.4.0/24'

// AKS Configuration
@description('AKS Cluster name')
param clusterName string = '${prefix}-cluster'

@description('Kubernetes version. Specify a specific version like "1.29.2" or leave empty to use the default version recommended by Azure')
param kubernetesVersion string = ''

@description('Node VM size')
param nodeVmSize string = 'Standard_DS3_v2'

@description('Node count')
param nodeCount int = 3

@description('Enable private cluster')
param enablePrivateCluster bool = true

// Virtual Network
module vnet '../../modules/networking/virtual-network/main.bicep' = {
  name: 'vnet-deployment'
  params: {
    vnetName: '${prefix}-vnet'
    location: location
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets: [
      {
        name: 'aks-subnet'
        addressPrefix: aksSubnetPrefix
        // Add required service endpoints for AKS
        serviceEndpoints: [
          {
            service: 'Microsoft.ContainerRegistry'
          }
          {
            service: 'Microsoft.Storage'
          }
        ]
        // For private clusters, allow private endpoints
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
      {
        name: 'pe-subnet'
        addressPrefix: peSubnetPrefix
        // For private endpoints
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
    tags: tags
  }
}

// Get subnet references
var aksSubnetId = '${vnet.outputs.vnetId}/subnets/aks-subnet'
var peSubnetId = '${vnet.outputs.vnetId}/subnets/pe-subnet'

// User-assigned Managed Identity for AKS cluster
resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${prefix}-aks-identity'
  location: location
  tags: tags
}

// Deploy AKS Cluster
module aks '../../modules/compute/aks-pvt/main.bicep' = {
  name: 'aks-deployment'
  params: {
    clusterName: clusterName
    location: location
    tags: tags
    kubernetesVersion: kubernetesVersion
    subnetId: aksSubnetId
    
    // Create as a private cluster
    enablePrivateCluster: enablePrivateCluster
    
    // Use CNI networking with Azure network policies
    networkPlugin: 'azure'
    networkPolicy: 'azure'
    
    // Enable Azure Container Insights
    enableContainerInsights: true
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
    
    // Use user-assigned managed identity
    identity: 'UserAssigned'
    userAssignedIdentityId: aksIdentity.id
    
    // Configure node pools
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: nodeCount
        vmSize: nodeVmSize
        mode: 'System'
        osType: 'Linux'
      }
    ]
  }
}

// Add Log Analytics Workspace for monitoring
module logAnalytics '../../modules/monitoring/log-analytics/main.bicep' = {
  name: 'law-deployment'
  params: {
    name: '${prefix}-law'
    location: location
    tags: tags
    retentionInDays: 30
    sku: 'PerGB2018'
  }
}

// Optional: Add Azure Key Vault with Private Endpoint
module keyVault '../../modules/security/key-vault/main.bicep' = {
  name: 'kv-deployment'
  params: {
    keyVaultName: '${take(replace(prefix, '-', ''), 8)}${uniqueString(resourceGroup().id)}'
    location: location
    tags: tags
    enableRbacAuthorization: true
    // Other Key Vault parameters as needed
  }
}

// Outputs
output vnetName string = vnet.outputs.vnetName
output vnetId string = vnet.outputs.vnetId
output aksClusterName string = aks.outputs.aksClusterName
output aksClusterId string = aks.outputs.aksClusterId
output logAnalyticsWorkspaceName string = logAnalytics.outputs.workspaceName
output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
