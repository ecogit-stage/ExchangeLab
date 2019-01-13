output "public_ip_address" {
  value = "${azurerm_public_ip.dmz.*.ip_address}"
}