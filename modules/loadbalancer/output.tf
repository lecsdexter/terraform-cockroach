output "lb_ip" {
    value = "${azurerm_public_ip.example.ip_address}"
}