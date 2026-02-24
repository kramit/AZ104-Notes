// storageaccount.bicep
targetScope = 'resourceGroup'

@description('Storage account name (3-24 chars, lowercase letters and numbers only). Must be globally unique.')
param storageAccountName string

@description('SKU for the storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param skuName string = 'Standard_LRS'

@description('Kind of storage account.')
@allowed([
  'StorageV2'
  'BlockBlobStorage'
  'FileStorage'
])
param kind string = 'StorageV2'

@description('Location for all resources.')
param location string = 'uksouth'

@description('Require HTTPS for all requests.')
param supportsHttpsTrafficOnly bool = true

@description('Minimum TLS version.')
@allowed([
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Allow public access to blobs (recommended false).')
param allowBlobPublicAccess bool = false

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  properties: {
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    accessTier: kind == 'StorageV2' ? 'Hot' : null
  }
}

output storageAccountId string = stg.id
output storageAccountName string = stg.name
output primaryEndpoints object = stg.properties.primaryEndpoints
