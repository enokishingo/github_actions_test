resource "azurerm_storage_account" "storage" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  min_tls_version            = var.min_tls_version
  https_traffic_only_enabled = var.enable_https_traffic

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.subnet_id]
  }

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
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
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
variable "account_tier" {}
variable "account_replication_type" {}
variable "min_tls_version" {}
variable "enable_https_traffic" {}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}