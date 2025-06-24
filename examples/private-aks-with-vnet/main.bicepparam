using 'main.bicep'

param prefix = 'aks-private'
param location = 'northeurope'
param tags = {
  environment: 'dev'
  project: 'AKS Private Cluster Demo'
}
param vnetAddressPrefix = '10.100.0.0/16'
param aksSubnetPrefix = '10.100.1.0/24'
param peSubnetPrefix = '10.0.2.0/24'
param clusterName = 'aks-private-cluster'
param kubernetesVersion = '1.31.8'
param nodeVmSize = 'Standard_DS3_v2'
param nodeCount = 3
param enablePrivateCluster = true
