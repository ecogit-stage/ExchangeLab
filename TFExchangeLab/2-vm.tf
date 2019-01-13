resource "azurerm_virtual_machine" "webdmz" {
  name                         = "${var.prefix}-dmz-${count.index}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  primary_network_interface_id = "${element(azurerm_network_interface.dmz.*.id, count.index)}"
  network_interface_ids        = ["${element(azurerm_network_interface.dmz.*.id, count.index)}", "${element(azurerm_network_interface.dmzlan.*.id, count.index)}"]
  vm_size                      = "${var.vm_size}"
  count                        = 2

  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = true
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"

    offer = "WindowsServer"

    sku = "2016-Datacenter"

    version = "latest"
  }

  storage_os_disk {
    name              = "${count.index+1}webosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-dmz-web-${count.index+1}"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "exc" {
  name                  = "${var.prefix}-mbx-${count.index+1}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${element(azurerm_network_interface.lanexc.*.id, count.index)}"]
  vm_size               = "${var.vm_size}"
  count                 = 2

  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = true
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"

    offer = "WindowsServer"

    sku = "2016-Datacenter"

    version = "latest"
  }

  storage_os_disk {
    name              = "${count.index+1}exosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-lan-mbx-${count.index+1}"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "dcs" {
  name                  = "${var.prefix}-dc-${count.index+1}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${element(azurerm_network_interface.landcs.*.id, count.index)}"]
  vm_size               = "${var.vm_size}"
  count                 = 2

  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = true
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"

    offer = "WindowsServer"

    sku = "2016-Datacenter"

    version = "latest"
  }

  storage_os_disk {
    name              = "${count.index+1}dcosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-lan-dc-${count.index+1}"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}
