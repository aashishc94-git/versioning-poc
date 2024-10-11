//container-app-env.bicep

param location string
param containerAppName string
param subnetId string

resource containerAppEnv 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: containerAppName
  location: location
  properties: {
    vnetConfiguration: {
      infrastructureSubnetId: subnetId
      internal: true // Putting behind vnet
    }
  }
}

output containerEnvName string = containerAppEnv.name
output domainName string  = containerAppEnv.properties.defaultDomain
