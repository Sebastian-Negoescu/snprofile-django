resource "azurerm_app_service" "webapp" {
    name = "${var.prefix}-app"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
    site_config {
        always_on = true
    }
}

resource "azurerm_app_service_slot" "webapp-develop" {
    name = "develop"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_name = "${azurerm_app_service.webapp.name}"
    app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
    site_config {
        always_on = true
    }
}

resource "azurerm_app_service_slot" "webapp-feature" {
    name = "feature"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_name = "${azurerm_app_service.webapp.name}"
    app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
    site_config {
        always_on = true
    }
}
# resource "azurerm_app_service_source_control" "webapp-github" {
#     app_service_id = "${azurerm_app_service.webapp.id}"
#     repo_url = "https://github.com/Sebastian-Negoescu/myprofile.git"
#     branch = "master"
#     is_manual_integration = true
# }