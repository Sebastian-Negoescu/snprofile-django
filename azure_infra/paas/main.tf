provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    tenant_id = "${var.tenant_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
}

resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = "${var.location}"
}

output "rg_name" {
    value = "${azurerm_resource_group.rg.name}"
}