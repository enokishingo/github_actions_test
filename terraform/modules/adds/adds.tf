resource "azurerm_active_directory_domain_service" "aadds" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  domain_name           = var.domain_name
  sku                   = var.sku
  filtered_sync_enabled = var.filtered_sync_enabled

  initial_replica_set {
    subnet_id = var.subnet_id
  }

  security {
    sync_kerberos_passwords = true
    sync_ntlm_passwords     = true
    sync_on_prem_passwords  = true
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
variable "domain_name" {}
variable "sku" {}
variable "filtered_sync_enabled" {}

output "domain_service_id" {
  value = azurerm_active_directory_domain_service.aadds.id
}