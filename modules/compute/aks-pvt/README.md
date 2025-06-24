# Azure Kubernetes Service (AKS) Bicep Module

This module deploys an Azure Kubernetes Service (AKS) cluster with options to configure as a private cluster with integration into an existing VNET.

## Features

- Support for private AKS cluster deployment
- Integration with existing VNet and subnet (Bring Your Own VNet)
- Configurable agent pool profiles
- Identity management (System-assigned or User-assigned)
- Network plugin and policy configuration
- Add-ons configuration (HTTP application routing, Azure Policy, Container Insights)

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| clusterName | string | | The name of the AKS cluster |
| location | string | resourceGroup().location | Location for the cluster |
| dnsPrefix | string | clusterName | Optional DNS prefix for the Kubernetes API server FQDN |
| osDiskSizeGB | int | 0 | Disk size (in GB) for each agent pool node |
| kubernetesVersion | string | '' | The version of Kubernetes. Specify a specific version like '1.29.2' or leave empty to use the default version recommended by Azure |
| networkPlugin | string | 'azure' | Network plugin used for Kubernetes networking |
| networkPolicy | string | 'azure' | Network policy used for Kubernetes networking |
| enableRBAC | bool | true | Enable RBAC for the cluster |
| enablePrivateCluster | bool | false | Enable private networking for the Kubernetes cluster |
| enableHttpApplicationRouting | bool | false | Enable HTTP application routing add-on |
| enableAzurePolicy | bool | false | Enable Azure Policy add-on |
| enableContainerInsights | bool | true | Enable container insights add-on |
| subnetId | string | | Subnet ID where the AKS nodes will be placed |
| userAssignedIdentityId | string | '' | ID of user-assigned managed identity for the cluster |
| identity | string | 'SystemAssigned' | Type of identity to use for the cluster |
| tags | object | {} | Resource tags |
| agentPoolProfiles | array | default system node pool | Agent pool configuration |
| apiServerAuthorizedIpRanges | array | [] | Authorized IP ranges for API server access |
| privateDNSZoneId | string | '' | Private DNS Zone ID for private cluster |
| privateClusterEndpoint | bool | enablePrivateCluster | Private cluster API server endpoint |
| logAnalyticsWorkspaceId | string | '' | Log Analytics Workspace ID for container monitoring |

## Outputs

| Output Name | Type | Description |
|-------------|------|-------------|
| aksClusterId | string | The resource ID of the AKS cluster |
| aksClusterName | string | The name of the AKS cluster |
| aksFqdn | string | The FQDN of the AKS API server |
| kubeletIdentityPrincipalId | string | The Kubelet identity principal ID |

## Usage

```bicep
module aks 'modules/compute/aks/main.bicep' = {
  name: 'aksDeployment'
  params: {
    clusterName: 'myPrivateAKSCluster'
    subnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/aks-subnet'
    enablePrivateCluster: true
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 3
        vmSize: 'Standard_DS3_v2'
        mode: 'System'
      }
      {
        name: 'userpool'
        count: 2
        vmSize: 'Standard_DS4_v2'
        mode: 'User'
        enableAutoScaling: true
        minCount: 2
        maxCount: 5
      }
    ]
  }
}
```

## Notes

- When deploying a private cluster, ensure that the subnet has the required service endpoints enabled
- For production deployments, consider using Azure CNI network plugin for advanced networking features
- Ensure your identity has sufficient permissions to create role assignments if using a managed identity
