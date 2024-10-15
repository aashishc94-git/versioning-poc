//container-registry.bicep
param location string 
param containerRegistryName string
param publicNetworkAccessCR string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistryName
  location: location  
  sku:{
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess:publicNetworkAccessCR
  }
}

output containerRegistryName string = containerRegistry.name
output containerRegistryId string = containerRegistry.id
output containerRegistryServer string = containerRegistry.properties.loginServer


