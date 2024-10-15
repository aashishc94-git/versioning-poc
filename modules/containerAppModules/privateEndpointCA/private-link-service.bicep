//private-link-service.bicep
param privateLinkServiceName string
param location string
param subnetName string
param subnetId string
param loadBalancerFrontEndIpConfigurationId string

resource privateLinkService 'Microsoft.Network/privateLinkServices@2021-05-01' = {
  name: privateLinkServiceName
  location: location
  properties: {
    enableProxyProtocol: false
    loadBalancerFrontendIpConfigurations: [
      {
        id: loadBalancerFrontEndIpConfigurationId
      }
    ]
    ipConfigurations: [
      {
        name: 'ipconfig-${subnetName}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion: 'IPv4'
          subnet: {
            id: subnetId
          }
          primary: true
        }
      }
    ]
  }
}

output privateLinkServiceId string = privateLinkService.id
