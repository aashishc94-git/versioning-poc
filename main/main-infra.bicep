//main-infra.bicep

targetScope = 'resourceGroup' /*Setting target scope of deployment as resource group*/

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

/*Creating 3 NSGs for subnets*/

module nsg1 '../modules/networkModules/network-sec-grp.bicep' = {
  name: 'nsg1'
  params: {
    location: location
    nsgName: 'network-sec-group-1-${environment}'
  }
}

module nsg2 '../modules/networkModules/network-sec-grp.bicep' = {
  name: 'nsg2'
  dependsOn: [
    nsg1
  ]
  params: {
    location: location
    nsgName: 'network-sec-group-2-${environment}'
  }
}

module nsg3 '../modules/networkModules/network-sec-grp.bicep' = {
  name: 'nsg3'
  dependsOn: [
    nsg1
    nsg2
  ]
  params: {
    location: location
    nsgName: 'network-sec-group-3-${environment}'
  }
}
/*Creating virtual network with 4 subnets*/

module virtualNetwork '../modules/networkModules/virtual-network.bicep' = {
  name: 'virtualNetwork'
  dependsOn: [
    nsg1
    nsg2
    nsg3
  ]
  params: {
    location: location 
    subnet1AddressPrefix: subnet1AddressPrefix
    subnet1Name: 'subnet-1-${environment}'
    nsg1Id: nsg1.outputs.nsgID
    subnet2AddressPrefix: subnet2AddressPrefix
    subnet2Name: 'subnet-2-${environment}'
    nsg2Id: nsg2.outputs.nsgID
    subnet3AddressPrefix: subnet3AddressPrefix
    subnet3Name: 'subnet-3-${environment}'
    nsg3Id: nsg3.outputs.nsgID
    subnet4AddressPrefix: subnet4AddressPrefix
    subnet4Name: 'AzureBastionSubnet'
    vnetAddressPrefix: vnetAddressPrefix
    vnetName: 'virtual-network-${environment}'
  }
}
/*Adding config rules for NSG1*/

module nsg1Rules '../modules/nsgModules/nsg-1.bicep' = {
  name: 'nsg1Rules'
  dependsOn:[
    virtualNetwork
    nsg1
  ]
  params: {
    nsgName: nsg1.outputs.nsgName
    subnet1Address: virtualNetwork.outputs.subnet1AddressPrefix
    subnet2Address: virtualNetwork.outputs.subnet2AddressPrefix
    subnet3Address: virtualNetwork.outputs.subnet3AddressPrefix
  }
}

/*Adding config rules for NSG2*/

module nsg2Rules '../modules/nsgModules/nsg-2.bicep' = {
  name: 'nsg2Rules'
  dependsOn:[
    virtualNetwork
    nsg2
  ]
  params: {
    location: location
    nsgName: nsg2.outputs.nsgName
    subnet1Address: virtualNetwork.outputs.subnet1AddressPrefix
    subnet2Address: virtualNetwork.outputs.subnet2AddressPrefix
    subnet3Address: virtualNetwork.outputs.subnet3AddressPrefix
  }
}

/*Adding config rules for NSG3*/

module nsg3Rules '../modules/nsgModules/nsg-3.bicep' = {
  name: 'nsg3Rules'
  dependsOn:[
    virtualNetwork
    nsg3
  ]
  params: {
    location: location
    nsgName: nsg3.outputs.nsgName
    subnet1Address: virtualNetwork.outputs.subnet1AddressPrefix
    subnet2Address: virtualNetwork.outputs.subnet2AddressPrefix
    subnet3Address: virtualNetwork.outputs.subnet3AddressPrefix
  }
}

/*Creating manage identity for Container Registry and Container App*/

module identity '../modules/managedIdentityModules/managed-identity.bicep' = {
  name: 'managedIdentity'
  params: {
    location: location
    managedIdentityName: 'managed-identity-${environment}'
  }
}

/*Encapsulating container registry creation and pushing a quickstart image(hello-world)*/

module containerRegistryWrapper '../modules/containerRegistryModules/wrapper-container-registry.bicep' = {
  name: 'containerRegistryWrapper'
  dependsOn: [
    identity
  ]
  params: {
    location: location
    containerRegisteryName: 'crcopdevops${environment}'
    deploymentName: 'deployHelloWorldAcr-${environment}'
    managedIdentityId: identity.outputs.managedIdentityId
  }
}

/*Encapsulating assignment of acr pull and push role to manage identity over container registery*/

module managedIdentityWrapper '../modules/managedIdentityModules/wrapper-managed-identity.bicep' = {
  name: 'managedIdentityWrapper'
  dependsOn:[
    containerRegistryWrapper
    identity
  ]
  params: {
    containerRegistryName: containerRegistryWrapper.outputs.containerRegistryName
    principalId: identity.outputs.managedIdentityPrincipaltId
  }
}
/*Encapsulating creating of private endpoint , private DNS and vnet link for container registry*/

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

/*Encapsulating creation of private endpoint , private link service, private DNS and vnet link for container app*/

module containerAppWrapper '../modules/containerAppModules/wrapper-container-app.bicep' = {
  name: 'containerAppWrapper'
  dependsOn: [
    virtualNetwork
    identity
    containerRegistryWrapper
  ]
  params: {
    location: location
    containerAppCpu: '1'
    subnetId: virtualNetwork.outputs.subnet1Id
    containerAppEnvName: 'containerapps-env-${environment}'
    containerAppMemory: '2Gi'
    containerAppName: 'containerapp-hw-${environment}'
    containerImageName: 'k8se/quickstart'
    managedIdentityName: identity.outputs.managedIdentityName
    containerRegistryName: containerRegistryWrapper.outputs.containerRegistryName
  }
}
/*Encapsulating creation of container app and container app enviorment*/

module privateLinkCaeWrapper '../modules/containerAppModules/privateEndpointCA/wrapper-pep-CA.bicep' = {
  name: 'privateLinkCaeWrapper'
  dependsOn: [
    containerAppWrapper
  ]
  params: {
    location: location
    domainNameCae: containerAppWrapper.outputs.domainName
    networkInterfaceName: 'nic-private-ep-cae-${environment}'
    privateEndpointName: 'private-ep-cae-${environment}'
    privateLinkServiceName: 'privatelink-service-cae-${environment}'
    subnetId: virtualNetwork.outputs.subnet1Id
    subnetName: virtualNetwork.outputs.subnet1Name
    vnetId: virtualNetwork.outputs.vnetId
  }
}

/*Encapsulationg creation of virtual machine and network interface*/

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
    nsgId: nsg3.outputs.nsgID
    subnetId: virtualNetwork.outputs.subnet3Id
    vmName: 'virtual-machine-${environment}'
    vmSize: vmSize
  }
}
/*Encapsulationg creation of public ip and bastion*/

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

