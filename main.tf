
module "resource_group"{
    source="./modules/resource_group"
    resource_group="${var.resource_group}"
    location="${var.location}"
}


module "network" {
  source               = "./modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "./modules/networksecuritygroup"
  location         = "${var.location}"
  resource_group   = "${module.resource_group.resource_group_name}"
  subnet_id        = "${module.network.subnet_id}"  
}

locals {
    numb_vs = "${var.number_virtual_machines}"
}

// Public IP for VMs
module "publicip" {
  count            = "${var.number_virtual_machines}" 
  source           = "./modules/publicip"
  location         = "${var.location}"
  resource_group   = "${module.resource_group.resource_group_name}"
  index            = "${count.index}"
}


module "virtualmachine" {
  count            = "${var.number_virtual_machines}"
  source           = "./modules/vm"
  location         = "${var.location}"
  resource_group   = "${module.resource_group.resource_group_name}"  
  subnet_id        = "${module.network.subnet_id}"
  public_ip        = "${module.publicip.*.public_ip_address_id[count.index]}" 
  index            = "${count.index}"
}



module "loadbalancer" {
  source            = "./modules/loadbalancer"
  location         = "${var.location}"
  resource_group   = "${module.resource_group.resource_group_name}" 
  nic_ids          = "${module.virtualmachine.*.vm_nic_id}"
  vnet_id          = "${module.network.vnet_id}"
  vm_ips           = "${module.virtualmachine.*.vm_ip}"
}



resource "local_file" "hosts_cfg"{
    content = templatefile("${path.module}/templates/hosts.tpl",
        {
            vm_ips = "${module.virtualmachine.*.vm_ip}"
        }
    )

    filename = "./ansible/inventory/inventory.in"
}






