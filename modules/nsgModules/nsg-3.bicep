//nsg-3.bicep

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

module nsg3 '../network-sec-grp.bicep' = {
  name: 'nsg3'
  params: {
    location: location
    nsgName: nsgName
  }
}

module nsg3Rule1InboundSubnet1 '../network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule1InboundSubnet1'
  dependsOn:[
    nsg3
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet1'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityGroupName: nsg3.outputs.nsgName
    priority: 100
    protocol: protocolTcp
    sourceAddressPrefix: subnet1Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg3Rule2InboundSubnet2 '../network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule2InboundSubnet2'
  dependsOn:[
    nsg3
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet2'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityGroupName: nsg3.outputs.nsgName
    priority: 110
    protocol: protocolTcp
    sourceAddressPrefix: subnet2Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg3Rule3OutboundSubnet1 '../network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule3OutboundSubnet1'
  dependsOn:[
    nsg3
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet1'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityGroupName: nsg3.outputs.nsgName
    priority: 120
    protocol: protocolTcp
    sourceAddressPrefix: subnet3Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg3Rule4OutboundSubnet1 '../network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule4OutboundSubnet1'
  dependsOn:[
    nsg3
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet3'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityGroupName: nsg3.outputs.nsgName
    priority: 130
    protocol: protocolTcp
    sourceAddressPrefix: subnet3Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

output nsg3Name string = nsg3.name
output nsg3Id string = nsg3.outputs.nsgID
