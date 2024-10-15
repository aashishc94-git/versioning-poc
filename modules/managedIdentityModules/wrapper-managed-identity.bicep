//wrapper-managed-identity.bicep

param containerRegistryName string
param principalId string


module acrPullRole 'role-acr-identity.bicep' = {
  name: guid(containerRegistryName,resourceGroup().id,'acrPullRole')
  params: {
    containerRegistryName: containerRegistryName
    principalId: principalId
    roleDefinitionAcrId: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  }
}

module acrPushRole 'role-acr-identity.bicep' = {
  name: guid(containerRegistryName,resourceGroup().id,'acrPushRole')
  params: {
    containerRegistryName: containerRegistryName
    principalId: principalId
    roleDefinitionAcrId: '8311e382-0749-4cb8-b61a-304f252e45ec'
  }
}
