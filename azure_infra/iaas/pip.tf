resource "azurerm_public_ip" "pip" {
    name = "${var.prefix}-pip"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${var.location}"
    public_ip_address_allocation = "Static"
    domain_name_label = "${var.prefix}-sn"
    sku = "Basic"
}

output "pip-fqdn" {
    value = "${azurerm_public_ip.pip.fqdn}"
}
output "pip-ip" {
    value = "${azurerm_public_ip.pip.ip_address}"
}