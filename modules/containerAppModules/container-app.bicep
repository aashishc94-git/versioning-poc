//container-app.bicep

param containerAppName string
param location string
param managedIdentityName string
param containerAppEnvName string
param containerImageName string
param containerAppCpu string
param containerAppMemory string 

param containerRegistryName string
param containerRegisterServer string = '${containerRegistryName}.azurecr.io'
param imageFullName string = '${containerRegisterServer}/${containerImageName}:latest'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: containerAppEnvName
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  identity:{
    type:'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}':{
        
      }
    }
  }
  properties: {
    managedEnvironmentId:containerAppEnv.id
    configuration: {
      registries: [
        {
          server: containerRegisterServer
          identity: managedIdentity.id
        }
      ]
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
      }
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: imageFullName
          resources: {
            cpu: json(containerAppCpu)
            memory: containerAppMemory
          }
        }
      ]
    }
  }
}
