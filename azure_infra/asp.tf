resource "azurerm_app_service_plan" "asp" {
    name = ""
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${var.location}"
    sku {
        capacity = 1
        size = "S1"
        tier = "Standard"
    }
}