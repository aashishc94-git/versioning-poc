//nsg-2.bicep

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
module nsg2 '../networkModules/network-sec-grp.bicep' = {
  name: 'nsg2'
  params: {
    location: location
    nsgName: nsgName
  }
}

module nsg2Rule1InboundSubnet1 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg2Rule1InboundSubnet1'
  dependsOn:[
    nsg2
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet1'
    destinationAddressPrefix: subnet2Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityGroupName: nsg2.outputs.nsgName
    priority: 100
    protocol: protocolTcp
    sourceAddressPrefix: subnet1Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg2Rule2InboundSubnet3 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg2Rule2InboundSubnet3'
  dependsOn:[
    nsg2
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet3'
    destinationAddressPrefix: subnet2Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityGroupName: nsg2.outputs.nsgName
    priority: 110
    protocol: protocolTcp
    sourceAddressPrefix: subnet3Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg2Rule3OutboundSubnet1 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg2Rule3OutboundSubnet1'
  dependsOn:[
    nsg2
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet1'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityGroupName: nsg2.outputs.nsgName
    priority: 120
    protocol: protocolTcp
    sourceAddressPrefix: subnet2Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg2Rule4OutboundSubnet3 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg2Rule4OutboundSubnet3'
  dependsOn:[
    nsg2
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet3'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityGroupName: nsg2.outputs.nsgName
    priority: 130
    protocol: protocolTcp
    sourceAddressPrefix: subnet2Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

output nsg2Name string = nsg2.name
output nsg2Id string = nsg2.outputs.nsgID

