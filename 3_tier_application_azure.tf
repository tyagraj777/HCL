#Purpose: Create a virtual network, subnets, and deploy a 3-tier application architecture.

provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "rg" {
  name     = "multi-tier-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "multi-tier-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_linux_virtual_machine" "web" {
  name                = "frontend-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ls"

  network_interface_ids = [azurerm_network_interface.frontend.id]

  admin_username = "adminuser"
  admin_password = "P@ssw0rd1234"
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-config"
    subnet_id                     = azurerm_subnet.subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
  }
}
