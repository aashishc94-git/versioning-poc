// private-endpoint-CA.bicep

param privateEndpointName string
param location string
param subnetId string
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
output networkInterfaceId string = split(privateEndpoint.properties.networkInterfaces[0].id,'/')[8]  // sub/subId/resGrp/resGrpId/providers/Microsoft.netw/netwInter/netwInterName/netwInterId
