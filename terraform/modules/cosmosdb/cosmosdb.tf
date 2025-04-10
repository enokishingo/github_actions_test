resource "azurerm_cosmosdb_account" "account" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = var.consistency_level
  }

  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
    }
  }

  backup {
    type                = var.backup.type
    interval_in_minutes = var.backup.interval_in_minutes
    retention_in_hours  = var.backup.retention_in_hours
  }

  is_virtual_network_filter_enabled = true

  virtual_network_rule {
    id = var.subnet_id
  }

  tags = {
    Environment = var.environment
  }
}

variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "subnet_id" {}
variable "sku" {
  type = object({
    name     = string
    capacity = number
  })
}
variable "consistency_level" {}
variable "geo_locations" {
  type = list(object({
    location          = string
    failover_priority = number
  }))
}
variable "backup" {
  type = object({
    type                = string
    interval_in_minutes = number
    retention_in_hours  = number
  })
}

output "endpoint" {
  value = azurerm_cosmosdb_account.account.endpoint
}