# Bicep Pre-Commit Hook

This pre-commit hook helps validate Bicep templates before committing them to the repository. It checks for:

1. Bicep syntax errors (via linting)
2. Build failures
3. Missing parameter descriptions
4. Missing resource tags
5. Potentially unsecured sensitive parameters

## Installation

To install the pre-commit hook:

```bash
# Navigate to your repository root
cd /path/to/bicep-templates

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy the pre-commit hook
cp .github/hooks/pre-commit .git/hooks/

# Make it executable
chmod +x .git/hooks/pre-commit
```

## Usage

Once installed, the pre-commit hook will automatically run whenever you attempt to commit changes that include Bicep files.

If any critical errors are found, the commit will be blocked until you fix them. Warnings will be displayed but will not block the commit.

## Bypassing the Hook

If you need to bypass the hook for a specific commit:

```bash
git commit --no-verify
```

However, this should be used sparingly and only in exceptional cases.

## Troubleshooting

If you encounter issues:

1. Ensure Azure CLI is installed and in your PATH
2. Verify that the Bicep extension is installed (`az bicep version`)
3. Check that the pre-commit hook is executable

## Updating

When the pre-commit hook is updated in the repository, you'll need to re-copy it to your local `.git/hooks` directory to use the latest version.
