# Create external disk
resource "azurerm_managed_disk" "mbx" {
  count                = "${var.number_of_disks}"
  name                 = "${var.prefix}-mbx-disk${count.index+1}"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "30"
}
