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
// module nsg2 '../networkModules/network-sec-grp.bicep' = {
//   name: 'nsg2'
//   params: {
//     location: location
//     nsgName: nsgName
//   }
// }
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' existing = {
  name: nsgName
}

module nsg2Rule1InboundSubnet1 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg2Rule1InboundSubnet1'
  dependsOn:[
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet1'
    destinationAddressPrefix: subnet2Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityRuleName: 'nsg2Rule1InboundSubnet1'
    nsgName:nsgName
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
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet3'
    destinationAddressPrefix: subnet2Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityRuleName: 'nsg2Rule2InboundSubnet3'
    nsgName:nsgName
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
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet1'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityRuleName: 'nsg2Rule3OutboundSubnet1'
    nsgName:nsgName
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
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet3'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityRuleName:  'nsg2Rule4OutboundSubnet3'
    nsgName:nsgName
    priority: 130
    protocol: protocolTcp
    sourceAddressPrefix: subnet2Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

