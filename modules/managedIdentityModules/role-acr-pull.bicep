//tole-acr-pull.bicep

param principalId string
param containerRegistryName string

param roleDefinitionId string = '7f951dda-4ed3-4680-a7ca-43fe172d538d' // add http
param principalType string = 'ServicePrincipal' // add http
param roleAssignmentName string = guid(principalId,resourceGroup().id,roleDefinitionId)

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: containerRegistryName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: roleAssignmentName
  scope: containerRegistry
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: principalType
    description: 'Pull container images from container registry.'
  }
}




