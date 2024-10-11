//wrapper-managed-identity.bicep

param location string
param managedIdentityName string
param containerRegistryName string

module identity 'managed-identity.bicep' = {
  name: 'managedIdentity'
  params: {
    location: location
    managedIdentityName: managedIdentityName
  }
}


module roleAcrPull 'role-acr-pull.bicep' = {
  name: 'roleAcrPull'
  dependsOn:[
    identity
  ]
  params: {
    containerRegistryName: containerRegistryName
    principalId: identity.outputs.managedIdentityPrincipaltId
  }
}

output managedIdentityName string = identity.name
