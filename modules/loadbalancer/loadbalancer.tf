resource "azurerm_public_ip" "example" {
  name                = "lb-cockroach"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress-cockroach"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

/* resource "azurerm_lb_nat_rule" "example" {
  //count                          = length(var.nic_ids)    
  resource_group_name            = "${var.resource_group}"
  loadbalancer_id                = azurerm_lb.example.id
  //name                           = "natrule-cockroachapp-${count.index}"
  name                           = "natrule-cockroachapp"
  protocol                       = "Tcp"
  frontend_port                  = 26257
  backend_port                   = 26257
  frontend_ip_configuration_name = "PublicIPAddress-cockroach"
}


resource "azurerm_lb_nat_rule" "example2" {  
  resource_group_name            = "${var.resource_group}"
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "natrule-ssh"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 26257
  frontend_ip_configuration_name = "PublicIPAddress-cockroach"
}  */

resource "azurerm_lb_rule" "lb_rule1" {
  resource_group_name            = "${var.resource_group}"
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "lbrule-cockroachapp"
  protocol                       = "Tcp"
  frontend_port                  = 26257
  backend_port                   = 26257
  frontend_ip_configuration_name = "PublicIPAddress-cockroach"
  //probe_id
}

resource "azurerm_lb_rule" "lb_rule2" {
  resource_group_name            = "${var.resource_group}"
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "lbrule-ssh"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress-cockroach"
  //probe_id
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}


/* resource "azurerm_lb_backend_address_pool_address" "example" {
  count                   = length(var.vm_ips)  
  name                    = "bapa-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  virtual_network_id      = var.vnet_id
  ip_address              = var.vm_ips[count.index]
} */

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = length(var.nic_ids)    
  //network_interface_id    = var.nic_ids[count.index]
  network_interface_id    = element(var.nic_ids, count.index) //fixes interpolation issues
  ip_configuration_name   = "internal-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}  









 resource "azurerm_lb_probe" "example" {
  resource_group_name = "${var.resource_group}"
  loadbalancer_id     = azurerm_lb.example.id
  name                = "health-8080-probe"
  port                = 8080
  protocol            = "Http"
  request_path        = "/health?ready=1"
}