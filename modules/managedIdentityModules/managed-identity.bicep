//managed-identity.bicep
param managedIdentityName string
param location string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

output managedIdentityPrincipaltId string = managedIdentity.properties.principalId
output managedIdentityName string = managedIdentity.name
output managedIdentityId string = managedIdentity.id
