//container-app.bicep

param containerAppName string
param location string
param managedIdentityName string
param containerAppEnvName string
param containerRegistry string
param containerImageName string
param containerAppCpu int
param containerAppMemory string 

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
          server: containerRegistry
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
          image: containerImageName
          resources: {
            cpu: containerAppCpu
            memory: containerAppMemory
          }
        }
      ]
      // scale container app using replicas
      scale: {
        minReplicas: 1
        maxReplicas: 3
      }
    }
  }
}
