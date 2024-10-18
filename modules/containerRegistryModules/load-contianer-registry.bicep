//load-container-registry.bicep

param utcValue string = utcNow()
param location string
param deploymentName string
param containerRegistryName string
param imageName string
param managedIdentityId string

resource acrDeploy 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: deploymentName
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.28.0'
    timeout: 'PT30M'
    scriptContent: 'az acr import --name ${containerRegistryName} --source mcr.microsoft.com --image ${imageName}'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}
