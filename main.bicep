targetScope = 'subscription'

@description('The Azure region where resources will be deployed')
param location string = deployment().location

@description('Name for the resource group')
param resourceGroupName string = 'my-storage-rg'

@description('The name of the storage account')
param storageAccountName string

@description('The name of the user-assigned managed identity')
param identityName string = 'storage-identity'

// Deploy the resource group and all resources
module resourceGroupDeployment 'resources.bicep' = {
  name: 'resource-group-deployment'
  params: {
    location: location
    resourceGroupName: resourceGroupName
    storageAccountName: storageAccountName
    identityName: identityName
  }
}

// Outputs
output resourceGroupId string = resourceGroupDeployment.outputs.resourceGroupId
output identityId string = resourceGroupDeployment.outputs.identityId
output identityPrincipalId string = resourceGroupDeployment.outputs.identityPrincipalId
output storageAccountId string = resourceGroupDeployment.outputs.storageAccountId
output storageAccountName string = resourceGroupDeployment.outputs.storageAccountName 
