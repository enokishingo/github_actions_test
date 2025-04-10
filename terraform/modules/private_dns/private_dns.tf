resource "azurerm_private_dns_zone" "zones" {
  for_each            = var.zones
  name                = each.value
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each              = azurerm_private_dns_zone.zones
  name                  = "${each.key}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.vnet_id

  tags = {
    Environment = var.environment
  }
}

variable "resource_group_name" {}
variable "environment" {}
variable "vnet_id" {}
variable "zones" {
  type        = map(string)
  description = "Map of DNS zone names. Key is the identifier, value is the zone name."
}

output "zone_ids" {
  value = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
}