// private-endpoint.bicep

param privateEndpointName string
param location string
param subnetId string
param groupId string
param resourceId string
param networkInterfaceName string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: privateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: resourceId
          groupIds: [
            groupId
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
    customNetworkInterfaceName: networkInterfaceName
  }
}

output privateEndpointName string = privateEndpoint.name
