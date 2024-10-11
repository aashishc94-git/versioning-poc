//private-Dns-zone.bicep

param globalPrivateDnsZone string = 'global'

param privateDnsZoneName string
param privateEndpointName string
param privateDnsConfigName string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' existing = {
  name: privateEndpointName
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: globalPrivateDnsZone
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  name: 'privateDnsZoneGroup'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsConfigName
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
