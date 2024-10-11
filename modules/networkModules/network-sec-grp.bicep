//network-sec-grp.bicep

param location string
param nsgName string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: nsgName
  location: location
}


output nsgID string = networkSecurityGroup.id
output nsgName string = networkSecurityGroup.name
