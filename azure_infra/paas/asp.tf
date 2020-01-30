resource "azurerm_app_service_plan" "asp" {
    name = "${var.prefix}-asp"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${var.location}"
    kind = "Linux"
    reserved = true
    sku {
        capacity = 1
        size = "S1"
        tier = "Standard"
    }
}