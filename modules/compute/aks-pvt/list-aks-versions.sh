#!/bin/bash
# List available Kubernetes versions for AKS
# This script lists the available Kubernetes versions for AKS in a specified region

set -e

LOCATION="eastus" # Default location for version check
FORMAT="table" # Default output format

# Function to display usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -l, --location      Azure region to check versions (default: eastus)"
  echo "  -f, --format        Output format (table, json, tsv, default: table)"
  echo "  -h, --help          Show this help message"
  exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -l|--location)
      LOCATION="$2"
      shift
      shift
      ;;
    -f|--format)
      FORMAT="$2"
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

echo "Fetching available Kubernetes versions from region: $LOCATION"
echo ""

# Display default version (this is what will be used if parameter is empty)
DEFAULT_VERSION=$(az aks get-versions --location $LOCATION --query 'orchestrators[?default].orchestratorVersion' -o tsv)
echo "Default version: $DEFAULT_VERSION (This will be used when kubernetesVersion parameter is empty)"
echo ""

# Display available versions based on format
if [[ "$FORMAT" == "json" ]]; then
  # Output JSON format
  az aks get-versions --location $LOCATION --output json
elif [[ "$FORMAT" == "tsv" ]]; then
  # Output simple list
  echo "Available versions (stable):"
  az aks get-versions --location $LOCATION --query "orchestrators[?isPreview==\`false\`].{Version:orchestratorVersion, Default:default}" -o tsv
  echo ""
  echo "Preview versions:"
  az aks get-versions --location $LOCATION --query "orchestrators[?isPreview==\`true\`].orchestratorVersion" -o tsv
else
  # Default table format
  echo "Available Kubernetes versions:"
  az aks get-versions --location $LOCATION --output table
fi

echo ""
echo "To specify a version in your deployment, set the kubernetesVersion parameter to one of the versions above."
echo "Example: kubernetesVersion = '$DEFAULT_VERSION'"
