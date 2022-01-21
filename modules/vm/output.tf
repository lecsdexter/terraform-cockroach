output "vm_ip" {
    value = "${azurerm_linux_virtual_machine.test.public_ip_address}"
}

output "vm_nic_id" {
    value = "${azurerm_network_interface.test.id}"
}

