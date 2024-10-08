param vnetName string
param subnetName string
param nsgName string

// Reference the existing Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

// Reference the existing Network Security Group (NSG)
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' existing = {
  name: nsgName
}

// Reference the existing subnet
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: subnetName
  parent: vnet
}

// Update the existing subnet by modifying address prefix and associating NSG
resource updatedSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: subnet.name
  parent: vnet
  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}
