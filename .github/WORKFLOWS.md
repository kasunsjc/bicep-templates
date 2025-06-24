# GitHub Actions Workflows for Bicep Validation

This repository includes comprehensive GitHub Actions workflows for validating Bicep templates and ensuring they meet quality, security, and compliance standards.

## Available Workflows

### 1. Basic Bicep Validation (`bicep-validation.yml`)

The standard workflow that runs on all Bicep files to ensure basic validation:

- Lints Bicep files for syntax errors
- Builds Bicep modules and examples
- Validates against Azure schema
- Runs ARM-TTK tests
- Checks documentation completeness

### 2. Enhanced Bicep Validation (`enhanced-bicep-validation.yml`)

A more thorough workflow that adds:

- Security scanning with Checkov
- Parameter file validation
- Resource tagging validation
- Bicep coding standards enforcement
- Dependency validation

### 3. AKS-Specific Validation (`aks-validation.yml`)

A specialized workflow for AKS modules:

- Validates AKS security features
- Checks for private cluster configuration
- Verifies VNET integration
- Validates Log Analytics integration
- Generates best practices report

## Workflow Triggers

The workflows are triggered by:

- Push to main/master branches
- Pull requests to main/master
- Changes to Bicep files or workflow files
- Manual triggering (workflow_dispatch)

## Validation Steps

### Security Checks

- **Checkov Scanning**: Identifies security issues in ARM templates
- **ARM-TTK Tests**: Validates against Azure best practices
- **Custom Security Policies**: Enforces repository-specific security rules
- **Resource Configuration**: Ensures resources are configured securely

### Quality Checks

- **Bicep Linting**: Validates syntax and structure
- **Parameter Description**: Ensures all parameters have descriptions
- **Output Description**: Ensures outputs are documented
- **README Validation**: Verifies module documentation exists

### Compliance Checks

- **Resource Tagging**: Validates resource tag usage
- **Naming Conventions**: Checks for consistent naming
- **Schema Validation**: Ensures compatibility with Azure Resource Manager

## Workflow Results

Workflow results are available in:

- GitHub Actions UI
- Job step summaries
- Workflow artifacts (reports)
- Workflow annotations on PRs

## Local Validation

To run similar validation locally before committing:

1. Install the pre-commit hook from `.github/hooks/`
2. Run `az bicep build` to validate syntax
3. Use the AKS policy validation script for AKS-specific checks

## Extending the Workflows

To extend these workflows:

1. Add new jobs to the workflow YAML files
2. Create new scripts in `.github/scripts/`
3. Update policy files in `.github/`

## References

- [ARM Template Toolkit (ARM-TTK)](https://github.com/Azure/arm-ttk)
- [Checkov IaC Security Scanner](https://github.com/bridgecrewio/checkov)
- [Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
