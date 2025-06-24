/*
  Log Analytics Workspace Module
  
  This module deploys a Log Analytics Workspace that can be used for monitoring.
*/

@description('Name of the Log Analytics Workspace')
param name string

@description('Azure region for the workspace')
param location string = resourceGroup().location

@description('The workspace data retention in days. -1 means Unlimited retention')
@minValue(-1)
@maxValue(730)
param retentionInDays int = 30

@description('Pricing tier: PerGB2018, Free, Standalone, PerNode, or Premium')
@allowed([
  'PerGB2018'
  'Free'
  'Standalone'
  'PerNode'
  'Premium'
])
param sku string = 'PerGB2018'

@description('The workspace daily quota for ingestion in GB. -1 means unlimited')
@minValue(-1)
param dailyQuotaGb int = -1

@description('Resource tags')
param tags object = {}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      immediatePurgeDataOn30Days: sku == 'Free' ? true : null
    }
    workspaceCapping: dailyQuotaGb != -1 ? {
      dailyQuotaGb: dailyQuotaGb
    } : null
  }
}

@description('The resource ID of the Log Analytics workspace')
output workspaceId string = workspace.id

@description('The resource name of the Log Analytics workspace')
output workspaceName string = workspace.name

@description('The customer ID of the Log Analytics workspace')
output customerId string = workspace.properties.customerId
