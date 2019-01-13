resource "azurerm_virtual_machine" "dmz1" {
  name                         = "${var.prefix}-dmz1"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  primary_network_interface_id = "${azurerm_network_interface.dmz1nic.id}"
  network_interface_ids        = ["${azurerm_network_interface.dmz1nic.id}", "${azurerm_network_interface.dmzlan1nic.id}"]
  vm_size                      = "Standard_DS1_v2"

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
    name              = "dmz1osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-dmz-web-01"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "dmz2" {
  name                         = "${var.prefix}-dmz2"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  primary_network_interface_id = "${azurerm_network_interface.dmz2nic.id}"
  network_interface_ids        = ["${azurerm_network_interface.dmz2nic.id}", "${azurerm_network_interface.dmzlan2nic.id}"]
  vm_size                      = "Standard_DS1_v2"

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
    name              = "dmzosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-dmz-web-02"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "mbx1" {
  name                  = "${var.prefix}-mbx1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.lan1nic.id}"]
  vm_size               = "Standard_D2S_v3"

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
    name              = "mbx1osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-lan-mbx-01"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "mbx2" {
  name                  = "${var.prefix}-mbx2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.lan2nic.id}"]
  vm_size               = "Standard_D2S_v3"

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
    name              = "mbx2osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-lan-mbx-02"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "dc1" {
  name                  = "${var.prefix}-dc1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.lan3nic.id}"]
  vm_size               = "Standard_DS1_v2"

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
    name              = "dc1osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-lan-dc-01"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}

resource "azurerm_virtual_machine" "dc2" {
  name                  = "${var.prefix}-dc2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.lan4nic.id}"]
  vm_size               = "Standard_DS1_v2"

  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = true
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "dc2osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.prefix}-lan-dc-02"

    admin_username = "${var.admin_username}"

    admin_password = "${var.admin_password}"
  }
}
