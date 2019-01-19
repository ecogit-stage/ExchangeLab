# Configure the Azure Provider
provider "azurerm" {}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resourcegroup}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vN" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_servers         = ["10.0.2.5", "10.0.2.6"]
}

resource "azurerm_subnet" "dmzsubnet" {
  name                 = "DMZ"
  address_prefix       = "10.0.1.0/24"
  virtual_network_name = "${azurerm_virtual_network.vN.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "lansubnet" {
  name                 = "LAN"
  address_prefix       = "10.0.2.0/24"
  virtual_network_name = "${azurerm_virtual_network.vN.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_public_ip" "dmz" {
  name                = "${var.prefix}-${count.index+1}-pip"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
  count               = 2
}

# Availability sets

resource "azurerm_availability_set" "exchange" {
  name = "${var.prefix}-exchange-as"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location = "${azurerm_resource_group.rg.location}"
  platform_update_domain_count = 2
  platform_fault_domain_count = 2
  managed = "true"
  
}
resource "azurerm_availability_set" "domaincontroller" {
  name = "${var.prefix}-dc-as"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location = "${azurerm_resource_group.rg.location}"
  platform_update_domain_count = 2
  platform_fault_domain_count = 2
  managed = "true"
  
}
resource "azurerm_availability_set" "dmz" {
  name = "${var.prefix}-dmz-as"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location = "${azurerm_resource_group.rg.location}"
  platform_update_domain_count = 2
  platform_fault_domain_count = 2
  managed = "true"
  
}


# Create a Network Security Group with some rules
resource "azurerm_network_security_group" "dmz" {
  name                = "${var.prefix}-dmz${count.index+1}-nsg"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = 2

  security_rule {
    name                       = "allow_HTTP"
    description                = "Allow HTTP access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_HTTPS"
    description                = "Allow HTTPS access"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_RDP"
    description                = "Allow RDP access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "dmz" {
  name                      = "${var.prefix}-dmz${count.index+1}-nic1"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${element(azurerm_network_security_group.dmz.*.id, count.index)}"
  count                     = 2

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.dmzsubnet.id}"
    private_ip_address            = "10.0.1.${count.index+10}"
    private_ip_address_allocation = "static"
    public_ip_address_id = "${element(azurerm_public_ip.dmz.*.id, count.index)}"
  }
}

# Network Interface DMZ Lan for IIS ARR
resource "azurerm_network_interface" "dmzlan" {
  name                = "${var.prefix}-dmzlan${count.index+1}-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = 2

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.${count.index+10}"
    private_ip_address_allocation = "static"
  }
}

# Nic Lan Exchange
resource "azurerm_network_interface" "lanexc" {
  name                = "${var.prefix}-lan-exc${count.index+1}nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = 2

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.${count.index+20}"
    private_ip_address_allocation = "static"
  }
}

# Nic LAN Domain controller 
resource "azurerm_network_interface" "landcs" {
  name                = "${var.prefix}-lan-dc${count.index+1}nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = 2

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.${count.index+5}"
    private_ip_address_allocation = "static"
  }
}
