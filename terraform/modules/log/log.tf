resource "azurerm_log_analytics_workspace" "log" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled     = var.internet_query_enabled

  tags = {
    Environment = var.environment
  }
}

variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "sku" {}
variable "retention_in_days" {}
variable "internet_ingestion_enabled" {}
variable "internet_query_enabled" {}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.log.id
}

output "workspace_key" {
  value     = azurerm_log_analytics_workspace.log.primary_shared_key
  sensitive = true
}