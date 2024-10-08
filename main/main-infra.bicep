//main-infra.bicep

targetScope = 'resourceGroup'

param location string
param environment string

param vnetAddressPrefix string

param subnet1AddressPrefix string
param subnet2AddressPrefix string
param subnet3AddressPrefix string
param subnet4AddressPrefix string


module virtualNetwork '../modules/network/virtual-network.bicep' = {
  name: 'virtualNetwork'
  params: {
    location: location 
    subnet1AddressPrefix: subnet1AddressPrefix
    subnet1Name: 'subnet-1-${environment}'
    subnet2AddressPrefix: subnet2AddressPrefix
    subnet2Name: 'subnet-2-${environment}'
    subnet3AddressPrefix: subnet3AddressPrefix
    subnet3Name: 'subnet-3-${environment}'
    subnet4AddressPrefix: subnet4AddressPrefix
    subnet4Name: 'AzureBastionSubnet'
    vnetAddressPrefix: vnetAddressPrefix
    vnetName: 'virtual-network-${environment}'
  }
}

module nsg1 '../modules/nsgModules/nsg-1.bicep' = {
  name: 'nsg1'
  dependsOn:[
    virtualNetwork
  ]
  params: {
    location: location
    nsgName: 'network-sec-group-1-${environment}'
    subnet1Address: virtualNetwork.outputs.subnet1AddressPrefix
    subnet2Address: virtualNetwork.outputs.subnet2AddressPrefix
    subnet3Address: virtualNetwork.outputs.subnet3AddressPrefix
  }
}

module nsg2 '../modules/nsgModules/nsg-2.bicep' = {
  name: 'nsg2'
  dependsOn:[
    virtualNetwork
  ]
  params: {
    location: location
    nsgName: 'network-sec-group-2-${environment}'
    subnet1Address: virtualNetwork.outputs.subnet1AddressPrefix
    subnet2Address: virtualNetwork.outputs.subnet2AddressPrefix
    subnet3Address: virtualNetwork.outputs.subnet3AddressPrefix
  }
}

module nsg3 '../modules/nsgModules/nsg-3.bicep' = {
  name: 'nsg3'
  dependsOn:[
    virtualNetwork
  ]
  params: {
    location: location
    nsgName: 'network-sec-group-3-${environment}'
    subnet1Address: virtualNetwork.outputs.subnet1AddressPrefix
    subnet2Address: virtualNetwork.outputs.subnet2AddressPrefix
    subnet3Address: virtualNetwork.outputs.subnet3AddressPrefix
  }
}

module attachSubnetNsg1 '../modules/network/attach-vnet-subnet.bicep' = {
  name: 'attachSubnetNsg1'
  dependsOn:[
    virtualNetwork
    nsg1
  ]
  params: {
    nsgName: nsg1.outputs.nsg1Name
    subnetName: virtualNetwork.outputs.subnet1Name
    vnetName: virtualNetwork.outputs.vnetName
  }
}

module attachSubnetNsg2 '../modules/network/attach-vnet-subnet.bicep' = {
  name: 'attachSubnetNsg2'
  dependsOn:[
    virtualNetwork
    nsg2
  ]
  params: {
    nsgName: nsg2.outputs.nsg2Name
    subnetName: virtualNetwork.outputs.subnet2Name
    vnetName: virtualNetwork.outputs.vnetName
  }
}

module attachSubnetNsg3 '../modules/network/attach-vnet-subnet.bicep' = {
  name: 'attachSubnetNsg3'
  dependsOn:[
    virtualNetwork
    nsg3
  ]
  params: {
    nsgName: nsg3.outputs.nsg3Name
    subnetName: virtualNetwork.outputs.subnet3Name
    vnetName: virtualNetwork.outputs.vnetName
  }
}

