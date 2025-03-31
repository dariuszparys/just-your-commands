@description('The Azure region where resources will be deployed')
param location string

@description('The name of the storage account')
param storageAccountName string

@description('The resource ID of the user-assigned managed identity')
param identityId string

@description('The principal ID of the user-assigned managed identity')
param identityPrincipalId string

@description('The SKU name for the storage account')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageAccountSku string = 'Standard_LRS'

@description('Allows HTTPS traffic only to storage service if set to true')
param supportsHttpsTrafficOnly bool = true

@description('Storage Account kind')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param storageAccountKind string = 'StorageV2'

@description('The access tier used for billing')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

var identities = {
  '${identityId}': {}
}

// Storage Blob Data Contributor role ID
var storageBlobDataContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: storageAccountKind
  sku: {
    name: storageAccountSku
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: identities
  }
  properties: {
    accessTier: accessTier
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'data'
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

// Role assignment for the managed identity to access the storage
// other services using this identity have access as contributor
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, identityPrincipalId, storageBlobDataContributorRoleId)
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: identityPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// Outputs
output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob 
