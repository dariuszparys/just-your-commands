# Azure Bicep Deployment with Just

This project uses [Just](https://github.com/casey/just) as a command runner to manage Azure Bicep deployments.

## Prerequisites

1. Install [Just](https://github.com/casey/just#installation)
2. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. Install [PowerShell](https://github.com/PowerShell/PowerShell#get-powershell)
4. Log in to Azure CLI:

   ```bash
   az login
   ```

## Environment Variables

Set the following environment variables before running the deployment:

```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export DEPLOYMENT_ENVIRONMENT="dev"  # Optional, defaults to "dev"
export AZURE_LOCATION="northeurope"  # Optional, defaults to "northeurope"
export DEPLOYMENT_NAME="just-demo"   # Optional, defaults to "just-demo"
export RESOURCE_GROUP_NAME="rg-just-demo"  # Optional, defaults to "rg-just-demo"
```

## Available Commands

### Validate Deployment

To validate the Bicep template and see what changes would be made:

```bash
just validate-all
```

This command will:

1. Lint the Bicep files
2. Validate the deployment
3. Show what-if changes

### Deploy

To deploy the infrastructure:

```bash
just deploy
```

### Clean Up

To delete the deployment and resource group:

```bash
just destroy
```

## Additional Commands

- `just help` - Lists all available commands
- `just lint` - Lints the Bicep files
- `just validate` - Validates the Bicep deployment
- `just what-if` - Shows what changes would be made by the deployment

## Notes

- The deployment uses PowerShell for Windows compatibility
- Resource group deletion is asynchronous (--no-wait flag)
- Make sure you have the necessary permissions in your Azure subscription
- The blog.just file is for reference only. It is discussed in the blog post [Just Your Commands](https://www.dariuszparys.com/just-your-commands)