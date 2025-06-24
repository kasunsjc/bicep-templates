# Log Analytics Workspace Bicep Module

This module deploys an Azure Log Analytics Workspace that can be used for monitoring various Azure resources, including Azure Kubernetes Service (AKS) clusters.

## Features

- Configurable SKU and retention periods
- Optional daily quota limits
- Integration with other monitoring services

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| name | string | | Name of the Log Analytics Workspace |
| location | string | resourceGroup().location | Location for the workspace |
| retentionInDays | int | 30 | The workspace data retention in days. -1 means Unlimited retention |
| sku | string | 'PerGB2018' | Pricing tier: PerGB2018, Free, Standalone, PerNode, or Premium |
| dailyQuotaGb | int | -1 | The workspace daily quota for ingestion in GB. -1 means unlimited |
| tags | object | {} | Resource tags |

## Outputs

| Output Name | Type | Description |
|-------------|------|-------------|
| workspaceId | string | The resource ID of the Log Analytics workspace |
| workspaceName | string | The resource name of the Log Analytics workspace |
| customerId | string | The customer ID of the Log Analytics workspace |

## Usage

```bicep
module logAnalytics 'modules/monitoring/log-analytics/main.bicep' = {
  name: 'logAnalyticsDeployment'
  params: {
    name: 'myLogAnalytics'
    location: 'eastus'
    retentionInDays: 30
    sku: 'PerGB2018'
    tags: {
      environment: 'production'
      project: 'myProject'
    }
  }
}
```

## Notes

- For production workloads, consider setting appropriate retention periods based on compliance requirements
- Free tier workspaces have limitations on data retention and ingestion volume
- For cost management, consider setting daily quotas for non-critical workspaces
