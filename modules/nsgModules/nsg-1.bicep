//nsg-1.bicep

param location string
param nsgName string
param subnet1Address string
param subnet2Address string
param subnet3Address string


param accessAllow string = 'Allow'
param port8080 string = '8080'
param directionInbound string = 'Inbound'
param directionOutbound string = 'Outbound'
param protocolTcp string = 'TCP'

module nsg1 '../network/network-sec-grp.bicep' = {
  name: 'nsg1'
  params: {
    location: location
    nsgName: nsgName
  }
}

module nsg1Rule1InboundSubnet2 '../network/network-sec-grp-rules.bicep' = {
  name: 'nsg1Rule1InboundSubnet2'
  dependsOn:[
    nsg1
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet2'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityGroupName: nsg1.outputs.nsgName
    priority: 100
    protocol: protocolTcp
    sourceAddressPrefix: subnet2Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg1Rule2InboundSubnet3 '../network/network-sec-grp-rules.bicep' = {
  name: 'nsg1Rule2InboundSubnet3'
  dependsOn:[
    nsg1
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet3'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityGroupName: nsg1.outputs.nsgName
    priority: 110
    protocol: protocolTcp
    sourceAddressPrefix: subnet3Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg1Rule3OutboundSubnet2 '../network/network-sec-grp-rules.bicep' = {
  name: 'nsg1Rule3OutboundSubnet2'
  dependsOn:[
    nsg1
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet2'
    destinationAddressPrefix: subnet2Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityGroupName: nsg1.outputs.nsgName
    priority: 120
    protocol: protocolTcp
    sourceAddressPrefix: subnet1Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg1Rule4OutboundSubnet3 '../network/network-sec-grp-rules.bicep' = {
  name: 'nsg1Rule4OutboundSubnet3'
  dependsOn:[
    nsg1
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet3'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityGroupName: nsg1.outputs.nsgName
    priority: 130
    protocol: protocolTcp
    sourceAddressPrefix: subnet1Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

output nsg1Name string = nsg1.name
output nsg1Id string = nsg1.outputs.nsgID

