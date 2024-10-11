//wrapper-pep-CA.bicep

param privateLinkServiceName string
param location string
param subnetName string
param subnetId string
param loadbalancerName string 
param loadBalancerFrontEndIpConfigurationName string

param networkInterfaceName string
param privateEndpointName string

param domainNameCae string
param vnetId string

module privateLinkService 'private-link-service.bicep' = {
  name: 'privateLinkService'
  params: {
    location: location
    loadBalancerFrontEndIpConfigurationName: loadBalancerFrontEndIpConfigurationName
    loadbalancerName: loadbalancerName
    privateLinkServiceName: privateLinkServiceName
    subnetId: subnetId
    subnetName: subnetName
  }
}

module privateEndPointCA 'private-endpoint-CA.bicep' = {
  name: 'privateEndPointCA'
  dependsOn:[
    privateLinkService
  ]
  params: {
    location: location
    networkInterfaceName: networkInterfaceName
    privateEndpointName: privateEndpointName
    resourceId: privateLinkService.outputs.privateLinkServiceId
    subnetId: subnetId
  }
}

module privateDnsZoneCA 'private-Dns-zone-CA.bicep' = {
  name: 'privateDnsZoneCA'
  dependsOn:[
    privateEndPointCA
  ]
  params: {
    domainNameCae: domainNameCae
    networkInterfaceName: privateEndPointCA.outputs.networkInterfaceId
    vnetId:vnetId
  }
}
