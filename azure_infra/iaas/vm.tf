resource "azurerm_virtual_machine" "vm" {
    name = "${var.prefix}-vm"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${var.location}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size = "Standard_D2s_v3"

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }

    storage_os_disk {
        name = "${var.prefix}_vm_datadisk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"
        disk_size_gb = 256
    }

    os_profile {
        computer_name = "myjenkinsbuilder"
        admin_username = "ansible"
    }

    os_profile_linux_config {
        disable_password_authentication = true

        ssh_keys {
            path = "/home/ansible/.ssh/authorized_keys"
            key_data = "${var.my_ssh_key}"
        }
    }
}