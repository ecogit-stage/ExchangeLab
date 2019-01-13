# Configure the Azure Provider
provider "azurerm" {}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
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

resource "azurerm_public_ip" "dmz1" {
  name                = "${var.prefix}-pip"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
}

# Create a Network Security Group with some rules
resource "azurerm_network_security_group" "dmz1" {
  name                = "${var.prefix}-dmz1-nsg"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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

resource "azurerm_network_security_group" "dmz2" {
  name                = "${var.prefix}-dmz2-nsg"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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

resource "azurerm_network_interface" "dmz1nic" {
  name                      = "${var.prefix}-dmz1-nic1"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.dmz1.id}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.dmzsubnet.id}"
    private_ip_address            = "10.0.1.10"
    private_ip_address_allocation = "static"
    public_ip_address_id          = "${azurerm_public_ip.dmz1.id}"
  }
}

resource "azurerm_network_interface" "dmz2nic" {
  name                      = "${var.prefix}-dmz2-nic1"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.dmz2.id}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.dmzsubnet.id}"
    private_ip_address            = "10.0.1.11"
    private_ip_address_allocation = "static"
  }
}

# Network Interface Lan
resource "azurerm_network_interface" "dmzlan1nic" {
  name                = "${var.prefix}-dmzlan1-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.10"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_network_interface" "dmzlan2nic" {
  name                = "${var.prefix}-dmzlan2-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.11"
    private_ip_address_allocation = "static"
  }
}


resource "azurerm_network_interface" "lan1nic" {
  name                = "${var.prefix}-lan1-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.20"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_network_interface" "lan2nic" {
  name                = "${var.prefix}-lan2-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.21"
    private_ip_address_allocation = "static"
  }
}

# Nic Domain controller 1
resource "azurerm_network_interface" "lan3nic" {
  name                = "${var.prefix}-lan3-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.5"
    private_ip_address_allocation = "static"
  }
}

# Nic Domain controller 2
resource "azurerm_network_interface" "lan4nic" {
  name                = "${var.prefix}-lan4-nic1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ip_Configuration"
    subnet_id                     = "${azurerm_subnet.lansubnet.id}"
    private_ip_address            = "10.0.2.6"
    private_ip_address_allocation = "static"
  }
}
