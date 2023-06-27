resource "azurerm_subnet" "apps" {
  name                 = "apps"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.0.192/28"]
}

resource "azurerm_network_interface" "demo" {
  location            = var.location
  name                = "${var.prefix}-demo-nic"
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.apps.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  admin_username        = "adminuser"
  location              = var.location
  name                  = "${var.prefix}-demo-vm"
  network_interface_ids = [azurerm_network_interface.demo.id]
  resource_group_name   = azurerm_resource_group.this.name
  size                  = var.size

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = local.tags
}

resource "azurerm_virtual_machine_extension" "demo_install" {
  name                       = "install"
  virtual_machine_id         = azurerm_linux_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = false
  protected_settings         = <<PROTECTED_SETTINGS
    {
      "script": "${base64encode("apt update && apt install -y nginx && echo 'Hello World!' > /var/www/html/index.html")}"
    }
    PROTECTED_SETTINGS

  tags = local.tags
}

output "private_ip" {
  value = azurerm_network_interface.demo.private_ip_address
}