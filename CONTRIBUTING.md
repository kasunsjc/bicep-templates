# Contributing to the Bicep Templates Repository

Thank you for your interest in contributing to our Azure Bicep Templates Repository! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful to others and follow our code of conduct in all interactions.

## How to Contribute

### Reporting Issues

- Check if the issue already exists in the issues section
- Use a clear, descriptive title
- Include detailed steps to reproduce the issue
- Specify the Bicep version and Azure CLI version you're using

### Submitting Changes

1. Fork the repository
2. Create a new branch from `main`
3. Make your changes
4. Test your changes thoroughly
5. Submit a Pull Request

### Pull Request Process

1. Provide a clear description of the changes
2. Link any related issues
3. Follow the module structure and design principles
4. Ensure all examples and tests work
5. Update documentation as needed

## Module Development Guidelines

### Folder Structure

Each module should follow this structure:

```text
modules/category/module-name/
├── main.bicep              # Main Bicep template
├── README.md               # Module documentation
├── test/                   # Test files
└── examples/               # Example deployments
    ├── parameters.json     # Example parameters
    └── main.bicep          # Example usage
```

### Naming Conventions

- Use kebab-case for file and folder names
- Use camelCase for parameters, variables, and outputs
- Use descriptive names that reflect the purpose

### Parameter Design

- Include a description for all parameters
- Provide sensible defaults where appropriate
- Use parameter constraints where applicable
- Group related parameters using object types

### Documentation

Each module should include:

1. Purpose and description
2. Required parameters
3. Optional parameters with defaults
4. Outputs
5. Example usage
6. Any limitations or considerations

### Testing

Before submitting a PR:

1. Validate the Bicep code: `az bicep build --file main.bicep`
2. Deploy the module in a test environment
3. Verify that all resources deploy correctly
4. Verify that outputs match expectations
5. Run any included tests

## Style Guide

### Bicep Style

- Use two spaces for indentation
- Group similar resources together
- Use comments for complex logic
- Follow [Bicep best practices](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices)

### Documentation Style

- Use clear, concise language
- Include code examples where helpful
- Use Markdown formatting consistently

## Review Process

All pull requests will be reviewed by the maintainers. We may suggest changes, improvements, or alternatives.

Thank you for your contributions! 🚀
