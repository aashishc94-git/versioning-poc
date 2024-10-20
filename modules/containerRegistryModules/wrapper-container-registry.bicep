//wrapper-container-registry.bicep

param location string
param containerRegisteryName string
param deploymentName string
param managedIdentityId string
param principalId string

module containerRegistry 'container-registry.bicep' = {
  name: 'containerRegistry'
  params: {
    location: location
    containerRegistryName: containerRegisteryName
    publicNetworkAccessCR: 'Disabled'
  }
}
/*Encapsulating assignment of acr pull and push role to manage identity over container registery*/

module managedIdentityRoleAcrWrapper '../managedIdentityModules/wrapper-managed-identity.bicep'= {
  name: 'managedIdentityRoleAcrWrapper'
  dependsOn:[
    containerRegistry
  ]
  params: {
    containerRegistryName: containerRegistry.outputs.containerRegistryName
    principalId: principalId
  }
}

module loadContainerRegistry 'load-contianer-registry.bicep' = {
  name: 'loadContainerRegistry'
  dependsOn: [
    containerRegistry
    managedIdentityRoleAcrWrapper
  ]
  params: {
    location: location
    containerRegistryName: containerRegistry.outputs.containerRegistryName
    deploymentName: deploymentName
    imageName: 'k8se/quickstart'
    managedIdentityId: managedIdentityId
  }
}

output containerRegistryName string = containerRegistry.outputs.containerRegistryName
output containerRegistryId string = containerRegistry.outputs.containerRegistryId
output containerRegistryServer string = containerRegistry.outputs.containerRegistryServer
