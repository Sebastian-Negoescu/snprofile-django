resource "azurerm_app_service" "webapp" {
    name = "${var.prefix}-app"
    location = "${var.prefix}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
}