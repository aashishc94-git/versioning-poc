//bastion.bicep

param bastionName string
param location string
param ipConfigName string
param publicIPAdressId string
param subnetId string

resource bastion 'Microsoft.Network/bastionHosts@2023-11-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: ipConfigName
        properties: {
          publicIPAddress: {
            id: publicIPAdressId
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}
