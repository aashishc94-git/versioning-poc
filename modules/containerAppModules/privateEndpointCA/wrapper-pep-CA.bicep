//wrapper-pep-CA.bicep

param privateLinkServiceName string
param location string
param subnetName string
param subnetId string
param networkInterfaceName string
param privateEndpointName string

param domainNameCae string
param domainPrefixCae string = split(domainNameCae,'.')[0]
param vnetId string
param kubernetesInternalLBName string = 'kubernetes-internal'
param caeInternalResourceGroupName string = 'MC_${domainPrefixCae}-rg_${domainPrefixCae}_${location}'

resource kubernetesInternalLB 'Microsoft.Network/loadBalancers@2024-01-01' existing = {
  name: kubernetesInternalLBName
  scope: resourceGroup(caeInternalResourceGroupName)
}
module privateLinkService 'private-link-service.bicep' = {
  name: 'privateLinkService'
  params: {
    location: location
    loadBalancerFrontEndIpConfigurationId: kubernetesInternalLB.properties.frontendIPConfigurations[0].id
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
