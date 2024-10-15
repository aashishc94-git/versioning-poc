//tole-acr-pull.bicep

param principalId string
param containerRegistryName string

param roleDefinitionAcrId string
param principalType string = 'ServicePrincipal' // add http
param roleAssignmentNamePull string = guid(principalId,resourceGroup().id,roleDefinitionAcrId)


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: containerRegistryName
}

resource pullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentNamePull
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',roleDefinitionAcrId) 
    principalId: principalId
    principalType: principalType
    description: 'Pull container images from container registry.'
  }
}



