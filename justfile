shebang := if os() == 'windows' {
  'pwsh.exe'
} else {
  '/usr/bin/env pwsh'
}
set shell := ["pwsh", "-c"]
set windows-shell := ["pwsh.exe", "-NoProfile", "-Command"]

subscription-id := env("AZURE_SUBSCRIPTION_ID")
environment := env("DEPLOYMENT_ENVIRONMENT", "dev")
location := env("AZURE_LOCATION", "northeurope")
deployment-name := env("DEPLOYMENT_NAME", "just-demo")
resourceGroupName := env("RESOURCE_GROUP_NAME", "rg-just-demo")

# Lists all available recipies
help:
    @just --list

# Lint the bicep files
lint:
    az bicep lint --file main.bicep

# Validates the bicep deployment
validate: _ensure-subscription
    #!{{ shebang }}
    az deployment sub validate `
        --name {{deployment-name}} `
        --location {{location}} `
        --template-file main.bicep `
        --parameters environments/{{environment}}.bicepparam `
        --parameters resourceGroupName={{resourceGroupName}}

# Shows what changes would be made by the deployment
what-if: _ensure-subscription
    #!{{ shebang }}
    az deployment sub what-if `
        --name {{deployment-name}} `
        --location {{location}} `
        --template-file main.bicep `
        --parameters environments/{{environment}}.bicepparam `
        --parameters resourceGroupName={{resourceGroupName}}

# Validates and shows what changes would be made by the deployment
validate-all: lint validate what-if

_ensure-subscription:
    az account set --subscription {{subscription-id}}

# Deploys the bicep deployment
deploy: _ensure-subscription
    #!{{ shebang }}
    az deployment sub create `
        --name {{deployment-name}} `
        --location {{location}} `
        --template-file main.bicep `
        --parameters environments/{{environment}}.bicepparam `
        --parameters resourceGroupName={{resourceGroupName}}

# Deletes the deployment and the resource group
destroy: _ensure-subscription
    #!{{ shebang }}
    Write-Host "Deleting deployment..."
    az deployment sub delete `
        --name {{deployment-name}} `
        --no-wait
    Write-Host "Checking if resource group exists..."
    $rgExists = az group exists --resource-group {{resourceGroupName}}
    if ($rgExists -eq "true") {
        Write-Host "Resource group '{{resourceGroupName}}' exists. Deleting..."
        az group delete --resource-group {{resourceGroupName}} --yes --no-wait
        Write-Host "Resource group deletion initiated"
    } else {
        Write-Host "Resource group '{{resourceGroupName}}' does not exist"
    }
    
