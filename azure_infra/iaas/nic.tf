resource "azurerm_network_interface" "nic" {
    name = "${var.prefix}-nic"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${var.location}"
    ip_configuration {
        name = "myNIC_Config"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "10.3.0.7"
        public_ip_address_id = "${azurerm_public_ip.pip.id}"
    }
}