provider "vsphere" {
  user                 = "Oharutz@pso-il.local"
  password             = "VMware1!"
  vsphere_server       = "10.23.204.111"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "PS-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "DS.204.38.2"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "PSO-Cluster01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "DPortGroup-LAN"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "foo"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = "other3xLinux64Guest"
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = 20
  }
}
