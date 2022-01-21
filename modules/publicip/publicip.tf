resource "azurerm_public_ip" "test" {
  name                = "pubip-cockroach-${var.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  allocation_method   = "Static"
  sku                 = "Standard"
}