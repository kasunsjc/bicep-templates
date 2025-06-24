using 'main.bicep'

param prefix = 'aks-private'
param location = 'eastus'
param tags = {
  environment: 'dev'
  project: 'AKS Private Cluster Demo'
}
param vnetAddressPrefix = '10.0.0.0/16'
param aksSubnetPrefix = '10.0.0.0/22'
param peSubnetPrefix = '10.0.4.0/24'
param clusterName = 'aks-private-cluster'
param kubernetesVersion = ''
param nodeVmSize = 'Standard_DS3_v2'
param nodeCount = 3
param enablePrivateCluster = true
