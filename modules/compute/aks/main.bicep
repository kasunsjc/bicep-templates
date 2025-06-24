/*
  Azure Kubernetes Service (AKS) Module
  
  This module deploys an AKS cluster with options to configure as a private cluster
  with integration into existing VNET and subnets.
*/

@description('The name of the Managed Cluster resource')
param clusterName string

@description('The location of the Managed Cluster resource')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN')
param dnsPrefix string = clusterName

@description('Disk size (in GB) to provision for each of the agent pool nodes')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The version of Kubernetes. Specify a specific version like "1.29.2" or leave empty to use the default version')
param kubernetesVersion string = ''

// TODO - Add use of Azure network plugin overlay
// TODO - Add Support for the cilium network plugin and other network policies
@description('Network plugin used for building Kubernetes network')
@allowed([
  'azure'
])
param networkPlugin string = 'azure'

@description('Network policy used for building Kubernetes network')
@allowed([
  'azure'
  'calico'
])
param networkPolicy string = 'azure'

@description('Boolean flag to turn on and off of RBAC')
param enableRBAC bool = true

@description('Enable private network access to the Kubernetes cluster')
param enablePrivateCluster bool = false

@description('Boolean flag to turn on and off http application routing')
param enableHttpApplicationRouting bool = false

@description('Boolean flag to turn on and off Azure Policy addon')
param enableAzurePolicy bool = false

@description('Boolean flag to turn on and off container insights')
param enableContainerInsights bool = true

@description('Subnet ID where the cluster nodes should be placed')
param subnetId string

@description('ID of the user-assigned managed identity for the cluster')
param userAssignedIdentityId string = ''

@description('Type of managed identity that should be assigned to the cluster')
@allowed([
  'SystemAssigned'
  'UserAssigned'
  'None'
])
param identity string = empty(userAssignedIdentityId) ? 'SystemAssigned' : 'UserAssigned'

@description('Resource tags')
param tags object = {}

@description('Agent pool configuration')
param agentPoolProfiles array = [
  {
    name: 'agentpool'
    count: 3
    vmSize: 'Standard_DS2_v2'
    mode: 'System'
    osType: 'Linux'
  }
]

@description('API server authorized IP ranges')
param apiServerAuthorizedIpRanges array = []

@description('Private DNS Zone ID for private cluster')
param privateDNSZoneId string = ''

@description('Private cluster API server endpoint')
param privateClusterEndpoint bool = enablePrivateCluster

@description('Log Analytics Workspace ID for container monitoring. If specified, AKS will send metrics to this workspace')
param logAnalyticsWorkspaceId string = ''

resource managedCluster 'Microsoft.ContainerService/managedClusters@2022-11-01' = {
  name: clusterName
  location: location
  tags: tags
  identity: {
    type: identity
    userAssignedIdentities: identity == 'UserAssigned' || identity == 'SystemAssigned, UserAssigned' ? {
      '${userAssignedIdentityId}': {}
    } : {}
  }
  properties: {
    kubernetesVersion: !empty(kubernetesVersion) ? kubernetesVersion : null
    dnsPrefix: dnsPrefix
    enableRBAC: enableRBAC
    
    // Network profile configuration
    networkProfile: {
      networkPlugin: networkPlugin
      networkPolicy: networkPolicy
      loadBalancerSku: 'standard'
    }
    
    // Agent pool configuration
    agentPoolProfiles: [for agentPool in agentPoolProfiles: {
      name: agentPool.name
      count: agentPool.count
      vmSize: agentPool.vmSize
      osDiskSizeGB: osDiskSizeGB == 0 ? null : osDiskSizeGB
      vnetSubnetID: subnetId
      mode: agentPool.?mode ?? 'System'
      osType: agentPool.?osType ?? 'Linux'
      type: agentPool.?type ?? 'VirtualMachineScaleSets'
      availabilityZones: agentPool.?availabilityZones
      enableAutoScaling: agentPool.?enableAutoScaling ?? false
      minCount: (agentPool.?enableAutoScaling ?? false) ? agentPool.?minCount : null
      maxCount: (agentPool.?enableAutoScaling ?? false) ? agentPool.?maxCount : null
      nodeLabels: agentPool.?nodeLabels
      nodeTaints: agentPool.?nodeTaints
    }]
    
    // Private cluster configuration
    apiServerAccessProfile: enablePrivateCluster ? {
      enablePrivateCluster: true
      privateDNSZone: !empty(privateDNSZoneId) ? privateDNSZoneId : null
      enablePrivateClusterPublicFQDN: !privateClusterEndpoint
      authorizedIPRanges: !empty(apiServerAuthorizedIpRanges) ? apiServerAuthorizedIpRanges : []
    } : {
      enablePrivateCluster: false
      authorizedIPRanges: !empty(apiServerAuthorizedIpRanges) ? apiServerAuthorizedIpRanges : []
    }
    
    // Add-ons configuration
    addonProfiles: {
      httpApplicationRouting: {
        enabled: enableHttpApplicationRouting
      }
      azurepolicy: {
        enabled: enableAzurePolicy
      }
      omsagent: enableContainerInsights ? {
        enabled: true
        config: !empty(logAnalyticsWorkspaceId) ? {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        } : {}
      } : {
        enabled: false
      }
    }
  }
}

@description('The resource ID of the AKS cluster')
output aksClusterId string = managedCluster.id

@description('The name of the AKS cluster')
output aksClusterName string = managedCluster.name

@description('The API server FQDN of the AKS cluster')
output aksFqdn string = managedCluster.properties.fqdn

@description('The Kubelet identity principal ID (if system assigned)')
output kubeletIdentityPrincipalId string = managedCluster.properties.identityProfile.kubeletidentity.objectId
