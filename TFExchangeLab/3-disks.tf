# Create external disk
resource "azurerm_managed_disk" "mbx1" {
  count                = "${var.number_of_disks}"
  name                 = "${var.prefix}-mbx1-disk${count.index+1}"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}

# Create external disk
resource "azurerm_managed_disk" "mbx2" {
  count                = "${var.number_of_disks}"
  name                 = "${var.prefix}-mbx2-disk${count.index+1}"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}

# Attach external disk
resource "azurerm_virtual_machine_data_disk_attachment" "mbx1" {
  count              = "${var.number_of_disks}"
  managed_disk_id    = "${azurerm_managed_disk.mbx1.*.id[count.index]}"
  virtual_machine_id = "${azurerm_virtual_machine.mbx1.id}"
  lun                = "${10+count.index}"
  caching            = "ReadWrite"
}

# Attach external disk
resource "azurerm_virtual_machine_data_disk_attachment" "mbx2" {
  count              = "${var.number_of_disks}"
  managed_disk_id    = "${azurerm_managed_disk.mbx2.*.id[count.index]}"
  virtual_machine_id = "${azurerm_virtual_machine.mbx2.id}"
  lun                = "${10+count.index}"
  caching            = "ReadWrite"
}