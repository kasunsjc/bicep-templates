#!/bin/bash
# Deploy a private AKS cluster with bring your own VNET

# Set variables
resourceGroupName="rg-aks-private"
location="eastus"
deploymentName="aks-private-deployment-$(date +%s)"

# Create resource group if it doesn't exist
echo "Creating resource group if it doesn't exist..."
az group create --name $resourceGroupName --location $location

# Deploy the Bicep template
echo "Deploying Bicep template..."
az deployment group create \
  --name $deploymentName \
  --resource-group $resourceGroupName \
  --template-file main.bicep \
  --parameters @parameters.json

# Check if deployment succeeded
if [ $? -eq 0 ]
then
  echo "Deployment successful!"
  
  # Get AKS cluster name
  aksClusterName=$(az deployment group show \
    --resource-group $resourceGroupName \
    --name $deploymentName \
    --query properties.outputs.aksClusterName.value \
    --output tsv)
  
  echo "Private AKS cluster '$aksClusterName' deployed successfully."
  echo ""
  echo "To connect to your private cluster, you'll need to use a jumpbox VM or a network connection to the VNET."
  echo ""
  echo "Example commands to use from a jumpbox VM:"
  echo "az aks get-credentials --resource-group $resourceGroupName --name $aksClusterName --admin"
  echo "kubectl get nodes"
else
  echo "Deployment failed. Check the error messages above."
fi
