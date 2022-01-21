resource "azurerm_resource_group" "rg_cockroach" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}