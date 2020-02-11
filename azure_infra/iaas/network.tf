resource "azurerm_virtual_network" "vnet" {
    name = "${var.prefix}-vnet"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    address_space = ["10.3.0.0/16"]
    location = "${var.location}"
}

resource "azurerm_subnet" "subnet" {
    name = "subnet01"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    address_prefix = "10.3.0.0/24"
}