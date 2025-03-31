targetScope = 'subscription'

@description('The Azure region where resources will be deployed')
param location string 

@description('Name for the resource group')
param resourceGroupName string

@description('The name of the storage account')
param storageAccountName string

@description('The name of the user-assigned managed identity')
param identityName string 

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// Deploy managed identity within the resource group
module identityDeployment 'identity.bicep' = {
  name: 'identity-deployment'
  scope: rg
  params: {
    location: location
    identityName: identityName
  }
}

// Deploy storage account within the resource group
module storageDeployment 'storage.bicep' = {
  name: 'storage-deployment'
  scope: rg
  params: {
    location: location
    storageAccountName: storageAccountName
    identityId: identityDeployment.outputs.identityId
    identityPrincipalId: identityDeployment.outputs.principalId
  }
}

// Outputs
output resourceGroupId string = rg.id
output identityId string = identityDeployment.outputs.identityId
output identityPrincipalId string = identityDeployment.outputs.principalId
output storageAccountId string = storageDeployment.outputs.storageAccountId
output storageAccountName string = storageDeployment.outputs.storageAccountName 
