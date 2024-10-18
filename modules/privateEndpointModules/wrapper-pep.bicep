//wrapper-pep.bicep

param privateEndpointName string
param location string
param subnetId string
param groupId string
param resourceId string
param networkInterfaceName string

param privateDnsZoneName string
param privateDnsConfigName string

param vnetId string

module privateEndPoint 'private-endpoint.bicep' = {
  name: 'privateEndPoint'
  params: {
    location: location
    groupId: groupId // https://blog.blksthl.com/2023/03/22/the-complete-list-of-groupids-for-private-endpoint-privatelink-service-connection/
    networkInterfaceName: networkInterfaceName
    privateEndpointName: privateEndpointName
    resourceId: resourceId
    subnetId: subnetId
  }
}

module privateDnsZoneResources 'private-Dns-zone.bicep' = {
  name: 'privateDnsZoneResources'
  dependsOn: [
    privateEndPoint
  ]
  params: {
    privateDnsConfigName: privateDnsConfigName
    privateDnsZoneName: privateDnsZoneName
    privateEndpointName: privateEndpointName
  }
}

module vnetLink 'vnet-link.bicep' = {
  name: 'vnetLink'
  params: {
    privateDnsZoneName: privateDnsZoneName
    vnetId: vnetId
  }
}
