resource "azurerm_private_dns_resolver" "resolver" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.vnet_id

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  name                    = var.inbound_endpoint.name
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = var.location
  subnet_id               = var.inbound_endpoint.subnet_id

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  name                    = var.outbound_endpoint.name
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = var.location
  subnet_id               = var.outbound_endpoint.subnet_id

  tags = {
    Environment = var.environment
  }
}

variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "vnet_id" {}
variable "inbound_endpoint" {
  type = object({
    name      = string
    subnet_id = string
  })
}
variable "outbound_endpoint" {
  type = object({
    name      = string
    subnet_id = string
  })
}

output "resolver_id" {
  value = azurerm_private_dns_resolver.resolver.id
}