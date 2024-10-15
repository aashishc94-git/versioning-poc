// wrapper-container-app.bicep

param location string
param containerAppName string
param subnetId string

param managedIdentityName string
param containerAppEnvName string
param containerImageName string
param containerAppCpu string
param containerAppMemory string 
param containerRegistryName string

module containerAppEnv 'container-app-env.bicep' = {
  name: 'containerAppEnv'
  params: {
    location: location
    containerAppName: containerAppEnvName
    subnetId: subnetId
  }
}

module containerApp 'container-app.bicep' = {
  name: 'containerApp'
  dependsOn: [
    containerAppEnv
  ]
  params: {
    location: location
    containerAppCpu: containerAppCpu
    containerAppEnvName: containerAppEnv.outputs.containerEnvName
    containerAppMemory: containerAppMemory
    containerAppName: containerAppName
    containerImageName: containerImageName
    managedIdentityName: managedIdentityName
    containerRegistryName: containerRegistryName
  }
}

output domainName string  = containerAppEnv.outputs.domainName
