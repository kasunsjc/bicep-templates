# Azure Bicep Templates Repository

A collection of reusable Azure Bicep modules to accelerate your Azure deployments and infrastructure as code initiatives.

![Bicep Logo](https://docs.microsoft.com/en-us/azure/templates/media/bicep.png)

## 📋 Overview

This repository contains modular, reusable Bicep templates that follow best practices for deploying resources in Azure. Each module is designed to be composable, configurable, and well-documented to help the community quickly implement infrastructure as code on Azure.

## 🏗️ Repository Structure

```
bicep-templates/
├── modules/                   # Reusable Bicep modules
│   ├── compute/              # VM, VMSS, Container Instances, etc.
│   ├── networking/           # VNets, NSGs, Load Balancers, etc.
│   ├── storage/              # Storage Accounts, File Shares, etc.
│   ├── security/             # Key Vaults, Managed Identities, etc.
│   └── databases/            # SQL, CosmosDB, etc.
├── examples/                  # Example deployments using modules
├── pipelines/                 # CI/CD pipeline definitions
├── scripts/                   # Utility scripts 
└── tests/                     # Module tests
```

## ⚙️ Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
- Azure subscription

## 🚀 Getting Started

### Install Bicep

```bash
# Install Bicep CLI
az bicep install

# Verify installation
az bicep version
```

### Deploy a Module

```bash
# Set your subscription
az account set --subscription <subscription-id>

# Deploy a storage account module
az deployment group create \
  --resource-group myResourceGroup \
  --template-file modules/storage/storage-account/main.bicep \
  --parameters @modules/storage/storage-account/examples/parameters.json
```

## 📦 Available Modules

### Compute

- Virtual Machines
- Virtual Machine Scale Sets
- Azure Kubernetes Service (AKS)
  - Private AKS clusters with Bring Your Own VNET
  - System and user node pools
- Container Instances

### Networking

- Virtual Networks
- Network Security Groups
- Load Balancers
- Application Gateways
- VPN Gateways

### Storage

- Storage Accounts
- Blob Containers
- File Shares

### Security

- Key Vault
- Managed Identities

### Databases

- Azure SQL
- CosmosDB
- MySQL/PostgreSQL

## 📖 Module Documentation

Each module includes:

- README with usage instructions
- Parameter descriptions and default values
- Output descriptions
- Example parameter files
- Example deployments

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to submit pull requests, create issues, and contribute modules.

## 📝 Module Design Principles

Our modules follow these principles:

1. **Composability**: Modules can be used together
2. **Configurability**: Sensible defaults with option to override
3. **Consistency**: Naming conventions and parameter patterns
4. **Testability**: Each module includes tests
5. **Documentation**: Clear documentation for usage

## 📄 License

This project is licensed under the [LICENSE](LICENSE) file in the repository.

---

Happy coding and deploying with Azure Bicep! 🚀
