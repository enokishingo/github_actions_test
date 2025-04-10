resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                = var.sku
  admin_enabled      = var.admin_enabled

  dynamic "georeplications" {
    for_each = var.geo_replications
    content {
      location = georeplications.value
      tags = {
        Environment = var.environment
      }
    }
  }

  public_network_access_enabled = false

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_private_endpoint" "pe" {
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${var.name}"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection          = false
    subresource_names            = ["registry"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "subnet_id" {}
variable "private_dns_zone_id" {}
variable "sku" {}
variable "admin_enabled" {}
variable "geo_replications" {
  type = list(string)
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}