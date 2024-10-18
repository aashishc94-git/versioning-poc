//role-acr-identity.bicep

param principalId string
param containerRegistryName string

param roleDefinitionAcrId string
param principalType string = 'ServicePrincipal' // add http
param roleAssignmentName string = guid(principalId,resourceGroup().id,roleDefinitionAcrId)


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: containerRegistryName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',roleDefinitionAcrId) 
    principalId: principalId
    principalType: principalType
    description: 'Manage identity role assignment from container registry.'
  }
}



