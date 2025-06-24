#!/bin/bash

# AKS Security Policy Validation Script
# This script checks Bicep templates for AKS security best practices

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Starting AKS Security Policy Validation..."

# Find all AKS module files
AKS_BICEP_FILES=$(find . -path "*/modules/compute/aks/*.bicep" -type f)

if [ -z "$AKS_BICEP_FILES" ]; then
    echo -e "${YELLOW}No AKS Bicep files found to validate.${NC}"
    exit 0
fi

# Initialize error counter
ERROR_COUNT=0
WARNING_COUNT=0

for file in $AKS_BICEP_FILES; do
    echo -e "\nValidating ${file}..."
    
    # Check for private cluster configuration
    if ! grep -q "enablePrivateCluster" "$file"; then
        echo -e "${YELLOW}[WARNING] Missing enablePrivateCluster parameter in $file${NC}"
        ((WARNING_COUNT++))
    fi
    
    # Check for network policy
    if ! grep -q "networkPolicy" "$file" && ! grep -q "networkPlugin" "$file"; then
        echo -e "${YELLOW}[WARNING] Missing network policy configuration in $file${NC}"
        ((WARNING_COUNT++))
    fi

    # Check for authorized IP ranges
    if ! grep -q "apiServerAccessProfile" "$file" && ! grep -q "authorizedIPRanges" "$file"; then
        echo -e "${YELLOW}[WARNING] Missing API server authorized IP ranges in $file${NC}"
        ((WARNING_COUNT++))
    fi
    
    # Check for Azure AD integration
    if ! grep -q "aadProfile" "$file"; then
        echo -e "${YELLOW}[WARNING] Consider adding Azure AD integration for AKS in $file${NC}"
        ((WARNING_COUNT++))
    fi
    
    # Check for Log Analytics workspace integration
    if ! grep -q "addonProfiles" "$file" && ! grep -q "omsagent" "$file"; then
        echo -e "${YELLOW}[WARNING] Missing Log Analytics integration in $file${NC}"
        ((WARNING_COUNT++))
    fi
    
    # Check for node auto-scaling settings
    if ! grep -q "autoScalerProfile" "$file" && ! grep -q "enableAutoScaling" "$file"; then
        echo -e "${YELLOW}[WARNING] Consider enabling cluster autoscaling in $file${NC}"
        ((WARNING_COUNT++))
    fi

    # Critical security checks
    
    # Check for managed identity usage
    if ! grep -q "identity:" "$file" && ! grep -q "type: 'SystemAssigned\\|UserAssigned'" "$file"; then
        echo -e "${RED}[ERROR] Missing managed identity configuration in $file${NC}"
        ((ERROR_COUNT++))
    fi
    
    # Check for RBAC enablement
    if ! grep -q "enableRBAC" "$file" || grep -q "enableRBAC: false" "$file"; then
        echo -e "${RED}[ERROR] RBAC must be enabled in $file${NC}"
        ((ERROR_COUNT++))
    fi
    
    # Check for AKS version parameter
    if ! grep -q "param kubernetesVersion string" "$file"; then
        echo -e "${RED}[ERROR] Missing kubernetesVersion parameter in $file${NC}"
        ((ERROR_COUNT++))
    fi
done

# Find all AKS example files
AKS_EXAMPLE_FILES=$(find ./examples -name "*.bicep" -type f -exec grep -l "Microsoft.ContainerService/managedClusters" {} \;)

for file in $AKS_EXAMPLE_FILES; do
    echo -e "\nValidating example ${file}..."
    
    # Check for networking configuration in examples
    if ! grep -q "vnetSubnetID:" "$file" && ! grep -q "subnetId:" "$file"; then
        echo -e "${YELLOW}[WARNING] Example $file might not be using custom VNET integration${NC}"
        ((WARNING_COUNT++))
    fi
    
    # Check for private cluster settings in examples
    if ! grep -q "enablePrivateCluster:" "$file"; then
        echo -e "${YELLOW}[WARNING] Example $file might not be configuring private cluster${NC}"
        ((WARNING_COUNT++))
    fi
done

# Summary
echo -e "\n===== AKS Security Policy Validation Summary ====="
if [ $ERROR_COUNT -eq 0 ] && [ $WARNING_COUNT -eq 0 ]; then
    echo -e "${GREEN}All AKS security checks passed!${NC}"
    exit 0
elif [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${YELLOW}Validation complete with $WARNING_COUNT warnings and no errors.${NC}"
    exit 0
else
    echo -e "${RED}Validation failed with $ERROR_COUNT errors and $WARNING_COUNT warnings.${NC}"
    echo -e "${RED}Please fix the errors before continuing.${NC}"
    exit 1
fi
