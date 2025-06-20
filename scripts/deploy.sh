#!/bin/bash

# Deploy Bicep Template Example
# This script helps with deploying examples from this repository

set -e

# Default values
TEMPLATE_PATH=""
PARAMETERS_PATH=""
RESOURCE_GROUP=""
LOCATION="eastus"

# Function to display usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -t, --template      Path to Bicep template file (required)"
  echo "  -p, --parameters    Path to parameters file (optional)"
  echo "  -g, --resource-group    Resource group name (required)"
  echo "  -l, --location      Azure region for deployment (default: eastus)"
  echo "  -h, --help          Show this help message"
  echo
  echo "Example:"
  echo "  $0 --template examples/web-app-with-storage/main.bicep --parameters examples/web-app-with-storage/parameters.json --resource-group my-rg"
  exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -t|--template)
      TEMPLATE_PATH="$2"
      shift
      shift
      ;;
    -p|--parameters)
      PARAMETERS_PATH="$2"
      shift
      shift
      ;;
    -g|--resource-group)
      RESOURCE_GROUP="$2"
      shift
      shift
      ;;
    -l|--location)
      LOCATION="$2"
      shift
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Check required parameters
if [[ -z "$TEMPLATE_PATH" ]]; then
  echo "Error: Template path is required"
  usage
fi

if [[ -z "$RESOURCE_GROUP" ]]; then
  echo "Error: Resource group name is required"
  usage
fi

# Check if template file exists
if [[ ! -f "$TEMPLATE_PATH" ]]; then
  echo "Error: Template file not found: $TEMPLATE_PATH"
  exit 1
fi

# Check if parameters file exists if provided
if [[ -n "$PARAMETERS_PATH" && ! -f "$PARAMETERS_PATH" ]]; then
  echo "Error: Parameters file not found: $PARAMETERS_PATH"
  exit 1
fi

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
  echo "Error: Azure CLI is not installed. Please install it first."
  echo "Visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
  exit 1
fi

# Check if logged in to Azure
echo "Checking Azure login..."
ACCOUNT=$(az account show --query name -o tsv 2>/dev/null || echo "")
if [[ -z "$ACCOUNT" ]]; then
  echo "Not logged in to Azure. Please login first."
  az login
fi

# Create resource group if it doesn't exist
echo "Checking if resource group exists: $RESOURCE_GROUP"
if ! az group show -g "$RESOURCE_GROUP" &>/dev/null; then
  echo "Creating resource group: $RESOURCE_GROUP in $LOCATION"
  az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
else
  echo "Resource group $RESOURCE_GROUP already exists"
fi

# Deploy the template
echo "Validating Bicep template: $TEMPLATE_PATH"
if [[ -n "$PARAMETERS_PATH" ]]; then
  az deployment group validate --resource-group "$RESOURCE_GROUP" --template-file "$TEMPLATE_PATH" --parameters "@$PARAMETERS_PATH"
  
  echo "Deploying Bicep template: $TEMPLATE_PATH with parameters: $PARAMETERS_PATH"
  az deployment group create --resource-group "$RESOURCE_GROUP" --template-file "$TEMPLATE_PATH" --parameters "@$PARAMETERS_PATH"
else
  az deployment group validate --resource-group "$RESOURCE_GROUP" --template-file "$TEMPLATE_PATH"
  
  echo "Deploying Bicep template: $TEMPLATE_PATH"
  az deployment group create --resource-group "$RESOURCE_GROUP" --template-file "$TEMPLATE_PATH"
fi

echo "Deployment completed successfully!"
