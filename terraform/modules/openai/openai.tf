resource "azurerm_cognitive_account" "openai" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = var.sku_name
  custom_subdomain_name = var.domain

  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.subnet_id
    }
  }

  tags = {
    Environment = var.environment
  }
}

variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "sku_name" {}
variable "subnet_id" {}
variable "domain" {}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}