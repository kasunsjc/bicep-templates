# Private AKS Cluster with Bring Your Own VNET

This example demonstrates how to deploy a private Azure Kubernetes Service (AKS) cluster using an existing Virtual Network with separate subnets for AKS nodes and private endpoints.

## Architecture Overview

![Private AKS Architecture](assets/private-aks-architecture.png)

This setup creates:

1. **Virtual Network** with two subnets:
   - AKS subnet for the Kubernetes nodes
   - Private endpoints subnet for services communication

2. **Private AKS Cluster** with:
   - Azure CNI networking
   - Azure network policy
   - Private API server endpoint
   - System node pool
   - Container Insights monitoring

3. **Supporting resources**:
   - Log Analytics workspace for Azure Monitor Container Insights
   - Key Vault (optional) for secrets management

## Prerequisites

- Azure subscription
- Azure CLI installed
- Bicep CLI installed

## Deployment Instructions

1. Clone this repository or download the example files.

2. Review and customize the `parameters.json` file to match your requirements.

3. Deploy using Azure CLI:

```bash
# Create a resource group
az group create --name rg-aks-private --location eastus

# Deploy the Bicep template
az deployment group create \
  --name aks-private-deployment \
  --resource-group rg-aks-private \
  --template-file main.bicep \
  --parameters @parameters.json
```

## Connecting to the Private Cluster

Since this deploys a private AKS cluster, the Kubernetes API server is only accessible from within the virtual network or from peered networks. To connect to the cluster, you will need to use one of the following methods:

1. Azure Bastion or a VM within the virtual network
2. Azure VPN or ExpressRoute connection
3. Azure CLI with Private Link

Example using a jumpbox VM:

```bash
# Get cluster admin credentials
az aks get-credentials --resource-group rg-aks-private --name aks-private-cluster --admin

# Run kubectl commands
kubectl get nodes
kubectl get pods --all-namespaces
```

## Customization Options

This example can be customized by:

- Adding additional node pools for specialized workloads
- Creating additional private endpoints for Azure services
- Integrating with other infrastructure components

## Kubernetes Version Management

This example uses a simple approach for Kubernetes version management:

- By default, the `kubernetesVersion` parameter is empty (`''`)
- When left empty, Azure will use the current default version for your region
- You can specify an exact version like `'1.29.2'` if you need a specific version
- This gives you direct control over the version while allowing Azure to handle defaults

To check available versions in your region before deployment:

```bash
# List available Kubernetes versions
az aks get-versions --location eastus --output table
```

## Monitoring Configuration

This deployment includes Azure Monitor Container Insights for comprehensive monitoring of your AKS cluster:

- A Log Analytics workspace is deployed and connected to your AKS cluster
- Container health, performance, and logs are automatically collected
- Pre-configured dashboards and alerts are available in the Azure Portal
- Integration with Azure Monitor for containerized applications monitoring

After deployment, you can access Container Insights from the Azure portal by:

1. Navigate to your AKS cluster
2. Select "Insights" from the left menu
3. View metrics, logs, and health status of your cluster and workloads

For custom monitoring solutions, you can use the deployed Log Analytics workspace to send additional logs and metrics.

## Notes

- The private AKS cluster requires outbound internet access for certain functionality unless you configure a fully private cluster with Azure Container Registry and other dependencies.
- Consider adding Azure Firewall to control outbound traffic.
- For production deployments, review security and networking best practices.
