resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-eastus-dev-cockroach"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  security_rule {
    name                       = "nsg-sr-cockroachadmin-80"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "nsg-sr-cockroachadmin-8080"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
        name                       = "nsg-sr-cockroachapp-26257"
        priority                   = 1300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "26257"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  security_rule {
        name                       = "nsg-sr-cockroachapp-SSH"
        priority                   = 1400
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }    
}
/* resource "azurerm_subnet_network_security_group_association" "test" {
    subnet_id                 = "${var.subnet_id}"
    network_security_group_id = azurerm_network_security_group.nsg.id
} */