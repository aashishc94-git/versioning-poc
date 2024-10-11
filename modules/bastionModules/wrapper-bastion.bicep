//wrapper-bastion.bicep

param location string
param publicIPAddressName string
param bastionName string
param ipConfigName string
param subnetId string

module publicIPAddress 'public-ip-address.bicep' = {
  name: 'publicIPAddress'
  params: {
    location: location
    publicIPAddressName: publicIPAddressName
  }
}

module bastion 'bastion.bicep' = {
  name: 'bastion'
  dependsOn: [
    publicIPAddress
  ]
  params: {
    location: location
    bastionName: bastionName
    ipConfigName: ipConfigName
    publicIPAdressId: publicIPAddress.outputs.publicIPAddressId
    subnetId: subnetId
  }
}
