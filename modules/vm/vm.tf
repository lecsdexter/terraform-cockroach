resource "azurerm_network_interface" "test" {
  name                = "nic-cockroach-${var.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal-${var.index}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip}"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.test.id
  network_security_group_id = "${var.nsg_id}"
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "vm-cockroach-${var.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_F2s_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
