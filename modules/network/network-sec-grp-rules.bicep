//network-sec-grp-rules.bicep

param networkSecurityGroupName string
param description string
param protocol string
param sourcePortRange string
param destinationPortRange string
param sourceAddressPrefix string
param destinationAddressPrefix string
param access string
param priority int
param direction string
param sourcePortRanges array
param destinationPortRanges array
param sourceAddressPrefixes array
param destinationAddressPrefixes array

resource networkSecurityGroupSecurityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2019-11-01' = {
  name: networkSecurityGroupName
  properties: {
    description: description
    protocol: protocol
    sourcePortRange: sourcePortRange
    destinationPortRange: destinationPortRange
    sourceAddressPrefix: sourceAddressPrefix
    destinationAddressPrefix: destinationAddressPrefix
    access: access
    priority: priority
    direction: direction
    sourcePortRanges:sourcePortRanges
    destinationPortRanges:destinationPortRanges
    sourceAddressPrefixes:sourceAddressPrefixes
    destinationAddressPrefixes:destinationAddressPrefixes
  }
}
