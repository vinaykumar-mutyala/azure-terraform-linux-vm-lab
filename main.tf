resource "azurerm_resource_group" "lab" {
  name     = "vinay-test"
  location = "East US"
}

resource "azurerm_virtual_network" "lab" {
  name                = "vnet-lab"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_subnet" "servers" {
  name                 = "servers"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "lab" {
  name                = "nsg-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}
resource "azurerm_network_security_rule" "rdp" {
  name                        = "Allow-RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "3389"

  source_address_prefix       = "*"
  destination_address_prefix  = "*"

  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.lab.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "Allow-SSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "22"

  source_address_prefix       = "*"
  destination_address_prefix  = "*"

  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.lab.name
}
resource "azurerm_subnet_network_security_group_association" "servers" {
  subnet_id                 = azurerm_subnet.servers.id
  network_security_group_id = azurerm_network_security_group.lab.id
}
resource "azurerm_public_ip" "linux" {
  name                = "pip-linux01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  allocation_method = "Static"
  sku               = "Standard"
}
resource "azurerm_network_interface" "linux" {
  name                = "nic-linux01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.servers.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux.id
  }
}
resource "azurerm_linux_virtual_machine" "linux" {
  name                = "vm-linux01"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location

  size           = "Standard_D2s_v3"
  admin_username = "azureadmin"

  network_interface_ids = [
    azurerm_network_interface.linux.id
  ]

  admin_ssh_key {
    username = "azureadmin"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD8sk//V55L+T3ig8xhtrDcTnlNz297dIx6XUlguDV4nM2mh+Zh7skNzz3SSa5o3SZdJofrfsEQ+0rGK4oulzcJocPwo0GGhxChTIIqQbFXJ1vQynIULGjX0nI4zqO6lc98WsU1KM7Cms8gLHUYsPWUoYir8LKkmwnFrUouz+x8/lGpqjekLfbwY5Xi/ziGg04Oeps1KO8ZumnTw55BxDHHv1Q0wuUwWqfhmX1JVWohDERcx97fTVvxWyCpK4N5Pcwwl0Jb+LaDA9sUTuak5SFnWNJmYNv/4DVXwiCmzN1FezxCtOa+nKWxu+IMlKpSIOdlheDxpdIWGP+VslFVHjWcslNvPM/H0Ff2bhI23dLv2qad6VkDrP8yD/h+cXLlQh8f3wNsBuHkj28/ty2NbWYuY0S2h9wvIs4y/KZF8LFRJ01LrLsqK+ney7qJ9nQv82VRZ2XjBVOsxf1OFgm4x8Yzu75sd1GusTh3sMtkw4Hf9BohwujkZeghLEH6n3vKRFdjK/YkxIt3Ud1Y6xnKwrKwOU18sv5aP2UEQxaZtcdPszhQ+EEVNudKNPs81OhTvyaopGtyCqkxyLIuEKaJwuF9XSsZ+W2uRZwpkQ/rUiU0zowebxO46iMLH9Zu5ixfZB7xFTWJf40JzVIUNIGaRy0cGvbLpKKsi5Vky8L0oruAuw== vinay@Vinnu"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}