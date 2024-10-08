//virtual-network.bicep
param vnetName string
param location string
param vnetAddressPrefix string

param subnet1Name string
param subnet2Name string
param subnet3Name string
param subnet4Name string

param subnet1AddressPrefix string
param subnet2AddressPrefix string
param subnet3AddressPrefix string
param subnet4AddressPrefix string


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1AddressPrefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2AddressPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.ContainerRegistry'
            }
          ]
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3AddressPrefix
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: subnet4AddressPrefix
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output vnetName string = virtualNetwork.name

output subnet1Id string = virtualNetwork.properties.subnets[0].id
output subnet1Name string = virtualNetwork.properties.subnets[0].name
output subnet1AddressPrefix string = virtualNetwork.properties.subnets[0].properties.addressPrefix

output subnet2Id string = virtualNetwork.properties.subnets[1].id
output subnet2Name string = virtualNetwork.properties.subnets[1].name
output subnet2AddressPrefix string = virtualNetwork.properties.subnets[1].properties.addressPrefix

output subnet3Id string = virtualNetwork.properties.subnets[2].id
output subnet3Name string = virtualNetwork.properties.subnets[2].name
output subnet3AddressPrefix string = virtualNetwork.properties.subnets[2].properties.addressPrefix

output subnet4Id string = virtualNetwork.properties.subnets[3].id
output subnet4Name string = virtualNetwork.properties.subnets[3].name
output subnet4AddressPrefix string = virtualNetwork.properties.subnets[3].properties.addressPrefix



