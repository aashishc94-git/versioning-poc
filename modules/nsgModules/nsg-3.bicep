//nsg-3.bicep
param nsgName string
param subnet1Address string
param subnet2Address string
param subnet3Address string


param accessAllow string = 'Allow'
param port8080 string = '8080'
param directionInbound string = 'Inbound'
param directionOutbound string = 'Outbound'
param protocolTcp string = 'TCP'


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' existing = {
  name: nsgName
}
module nsg3Rule1InboundSubnet1 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule1InboundSubnet1'
  dependsOn:[
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet1'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityRuleName: 'nsg3Rule1InboundSubnet1'
    nsgName:nsgName
    priority: 100
    protocol: protocolTcp
    sourceAddressPrefix: subnet1Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg3Rule2InboundSubnet2 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule2InboundSubnet2'
  dependsOn:[
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow inbound traffic from subnet2'
    destinationAddressPrefix: subnet3Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionInbound
    networkSecurityRuleName: 'nsg3Rule2InboundSubnet2'
    nsgName:nsgName
    priority: 110
    protocol: protocolTcp
    sourceAddressPrefix: subnet2Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg3Rule3OutboundSubnet1 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule3OutboundSubnet1'
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
    networkSecurityRuleName: 'nsg3Rule3OutboundSubnet1'
    nsgName:nsgName
    priority: 120
    protocol: protocolTcp
    sourceAddressPrefix: subnet3Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}

module nsg3Rule4OutboundSubnet1 '../networkModules/network-sec-grp-rules.bicep' = {
  name: 'nsg3Rule4OutboundSubnet1'
  dependsOn:[
    networkSecurityGroup
  ]
  params: {
    access: accessAllow
    description: 'Allow outbound traffic from subnet3'
    destinationAddressPrefix: subnet1Address
    destinationAddressPrefixes: []
    destinationPortRange: port8080
    destinationPortRanges: []
    direction: directionOutbound
    networkSecurityRuleName: 'nsg3Rule4OutboundSubnet1'
    nsgName:nsgName
    priority: 130
    protocol: protocolTcp
    sourceAddressPrefix: subnet3Address
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
}
