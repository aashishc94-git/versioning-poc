//main-infra.bicep

targetScope = 'resourceGroup'

param location string
param environment string

param vnetAddressPrefix string

param subnet1AddressPrefix string
param subnet2AddressPrefix string
param subnet3AddressPrefix string
param subnet4AddressPrefix string

param adminUserName string
@secure()
param adminPassword string
param vmSize string

module virtualNetwork '../modules/networkModules/virtual-network.bicep' = {
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

module attachSubnetNsg1 '../modules/networkModules/attach-vnet-subnet.bicep' = {
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

module attachSubnetNsg2 '../modules/networkModules/attach-vnet-subnet.bicep' = {
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

module attachSubnetNsg3 '../modules/networkModules/attach-vnet-subnet.bicep' = {
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

module containerRegistryWrapper '../modules/containerRegistryModules/wrapper-container-registry.bicep' = {
  name: 'containerRegistryWrapper'
  params: {
    location: location
    containerRegisteryName: 'container-registry-${environment}'
    deploymentName: 'deployHelloWorldAcr-${environment}'
  }
}

module managedIdentityWrapper '../modules/managedIdentityModules/wrapper-managed-identity.bicep' = {
  name: 'managedIdentityWrapper'
  dependsOn:[
    containerRegistryWrapper
  ]
  params: {
    location: location
    containerRegistryName: containerRegistryWrapper.outputs.containerRegistryName
    managedIdentityName: 'managed-identity-${environment}'
  }
}

module privateEndpointContainerRegistry '../modules/privateEndpointModules/wrapper-pep.bicep' = {
  name: 'privateEndpointContainerRegistry'
  dependsOn:[
    containerRegistryWrapper
    virtualNetwork
  ]
  params: {
    location: location
    groupId: 'registry'
    networkInterfaceName: 'nic-private-pep-cr-${environment}'
    privateDnsConfigName: 'privatelink-azurecr-io'
    privateDnsZoneName: 'privatelink.azurecr.io'
    privateEndpointName: 'private-pep-cr-${environment}'
    resourceId: containerRegistryWrapper.outputs.containerRegistryId
    subnetId: virtualNetwork.outputs.subnet2Id
    vnetId: virtualNetwork.outputs.vnetId
  }
}

module containerAppEnv '../modules/containerAppModules/container-app-env.bicep' = {
  name: 'containerAppEnv'
  dependsOn:[
    virtualNetwork
  ]
  params: {
    location: location
    containerAppName: 'containerapps-env-${environment}'
    subnetId: virtualNetwork.outputs.subnet1Id
  }
}

module containerApp '../modules/containerAppModules/container-app.bicep' = {
  name: 'containerApp'
  dependsOn: [
    containerAppEnv
    containerRegistryWrapper
    managedIdentityWrapper
  ]
  params: {
    location: location
    containerAppCpu: 2
    containerAppEnvName: containerAppEnv.outputs.containerEnvName
    containerAppMemory: '2Gi'
    containerAppName: 'containerapp-hw-${environment}'
    containerImageName: 'hello-world'
    containerRegistry: containerRegistryWrapper.outputs.containerRegistryServer
    managedIdentityName: managedIdentityWrapper.outputs.managedIdentityName
  }
}

module privateLinkCaeWrapper '../modules/containerAppModules/privateEndpointCA/wrapper-pep-CA.bicep' = {
  name: 'privateLinkCaeWrapper'
  params: {
    location: location
    domainNameCae: containerAppEnv.outputs.domainName
    loadBalancerFrontEndIpConfigurationName: 'b77jhecsj7w36r9w8hjcjwr3r'
    loadbalancerName: 'kubernetes-internal'
    networkInterfaceName: 'nic-private-ep-cae-${environment}'
    privateEndpointName: 'private-ep-cae-${environment}'
    privateLinkServiceName: 'privatelink-service-cae-${environment}'
    subnetId: virtualNetwork.outputs.subnet1Id
    subnetName: virtualNetwork.outputs.subnet1Name
    vnetId: virtualNetwork.outputs.vnetId
  }
}

module wrapperVirtualMachine '../modules/vmModules/wrapper-vm.bicep' = {
  name: 'wrapperVirtualMachine'
  dependsOn: [
    virtualNetwork
    nsg3
  ]
  params: {
    location: location
    adminPassword: adminPassword
    adminUserName: adminUserName
    nicName: 'network-interface-vm-${environment}'
    nsgId: nsg3.outputs.nsg3Id
    subnetId: virtualNetwork.outputs.subnet3Id
    vmName: 'virtual-machine-${environment}'
    vmSize: vmSize
  }
}

module wrapperBastion '../modules/bastionModules/wrapper-bastion.bicep' = {
  name: 'wrapperBastion'
  params: {
    location: location
    bastionName: 'bastion-${environment}'
    ipConfigName: 'ipconfig-bastion-${environment}'
    publicIPAddressName: 'public-ip-bastion-${environment}'
    subnetId: virtualNetwork.outputs.subnet4Id
  }
}

