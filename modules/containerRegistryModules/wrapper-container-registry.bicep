//wrapper-container-registry.bicep

param location string
param containerRegisteryName string
param deploymentName string
param managedIdentityId string

module containerRegistry 'container-registry.bicep' = {
  name: 'containerRegistry'
  params: {
    location: location
    containerRegistryName: containerRegisteryName
    publicNetworkAccessCR: 'Disabled'
  }
}

// module loadContainerRegistry 'load-contianer-registry.bicep' = {
//   name: 'loadContainerRegistry'
//   dependsOn: [
//     containerRegistry
//   ]
//   params: {
//     location: location
//     containerRegistryName: containerRegistry.outputs.containerRegistryName
//     deploymentName: deploymentName
//     imageName: 'hello-world'
//     managedIdentityId: managedIdentityId
//   }
// }

output containerRegistryName string = containerRegistry.outputs.containerRegistryName
output containerRegistryId string = containerRegistry.outputs.containerRegistryId
output containerRegistryServer string = containerRegistry.outputs.containerRegistryServer
