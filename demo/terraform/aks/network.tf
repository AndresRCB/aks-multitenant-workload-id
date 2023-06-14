resource "azurerm_virtual_network" "main" {
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.main.location
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    purpose = "dps-testing"
  }
}

resource "azurerm_subnet" "main" {
  address_prefixes     = [var.subnet_cidr]
  name                 = var.subnet_name
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
}

data "http" "myip" {
  url = "https://api.ipify.org"
}

resource "azurerm_network_security_group" "main" {
  location            = azurerm_resource_group.main.location
  name                = "nsg-${azurerm_subnet.main.name}"
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    purpose = "testing"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowCidrBlockInbound"
    priority                   = 3000
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    destination_port_ranges    = ["80", "443", "8883"]
    source_address_prefix      = var.authorized_ip_cidr_range == "" ? "${chomp(data.http.myip.response_body)}/32" : var.authorized_ip_cidr_range
    source_port_range          = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  network_security_group_id = azurerm_network_security_group.main.id
  subnet_id                 = azurerm_subnet.main.id
}

