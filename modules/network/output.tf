
output "subnet_id" {
  value = "${azurerm_subnet.test.id}"
}

output "vnet_id" {
  value = "${azurerm_virtual_network.test.id}"
}
