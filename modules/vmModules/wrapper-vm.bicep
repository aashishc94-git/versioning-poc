// wrapper-vm.bicep
param location string
param nicName string
param nsgId string
param subnetId string

param adminUserName string
@secure()
param adminPassword string
param vmName string
param vmSize string

module networkInterface 'network-interface.bicep' = {
  name: 'networkInterface'
  params: {
    location: location
    networkInterfaceName: nicName
    nsgId: nsgId
    subnetId: subnetId
  }
}

module virtualMachine 'virtual-machine.bicep' = {
  name: 'virtualMachine'
  dependsOn: [
    networkInterface
  ]
  params: {
    location: location
    adminPassword: adminPassword
    adminUserName: adminUserName
    networkInterfaceId: networkInterface.outputs.networkInterfaceId
    vmName: vmName
    vmSize: vmSize
  }
}
