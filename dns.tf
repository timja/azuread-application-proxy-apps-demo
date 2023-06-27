resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone
  resource_group_name = azurerm_resource_group.this.name

  tags = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "app-proxy"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id

  registration_enabled = true

  tags = local.tags
}
