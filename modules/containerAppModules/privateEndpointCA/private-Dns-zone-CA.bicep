//private-Dns-zone-CA.bicep

param globalZone string = 'global'
param vnetId string
param domainNameCae string
param networkInterfaceName string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: domainNameCae
  location: globalZone
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-11-01' existing = {
  name: networkInterfaceName
}

resource record 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '*'
  dependsOn:[
    networkInterface
  ]
  properties: {
   ttl:3600
   aRecords:[
    {
      ipv4Address: networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
    }
   ]
  }
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: uniqueString(vnetId)
  location: globalZone
  parent: privateDnsZone
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}

