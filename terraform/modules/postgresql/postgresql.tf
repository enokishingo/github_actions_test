resource "azurerm_postgresql_flexible_server" "server" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login    = var.admin_login
  administrator_password = var.admin_password

  sku_name = var.sku.name
  version  = var.postgresql_version

  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  zone = "1"

  public_network_access_enabled = false

  tags = {
    Environment = var.environment
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres
  ]
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.name
  server_id = azurerm_postgresql_flexible_server.server.id
  charset   = var.charset
  collation = var.collation
}

# Flexible Serverに必要なPrivate DNS Zone
resource "azurerm_private_dns_zone" "postgres" {
  name                = "postgres.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-link-${var.name}"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
}

# 変数定義
variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "subnet_id" {}
variable "vnet_id" {}
variable "postgresql_version" {}
variable "sku" {
  type = object({
    name     = string
    capacity = number
    tier     = string
    family   = string
  })
}
variable "storage_mb" {}
variable "backup_retention_days" {}
variable "geo_redundant_backup" {}
variable "charset" {}
variable "collation" {}
variable "admin_login" {
  sensitive = true
  default   = "psqladmin"
}
variable "admin_password" {
  sensitive = true
}

# 出力
output "server_id" {
  value = azurerm_postgresql_flexible_server.server.id
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.server.fqdn
}

output "database_id" {
  value = azurerm_postgresql_flexible_server_database.db.id
}