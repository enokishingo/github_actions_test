resource "azurerm_virtual_wan" "vwan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = var.type

  allow_branch_to_branch_traffic = var.branch_to_branch_traffic

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_virtual_hub" "hub" {
  name                = var.hub_name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = var.hub_address_prefix
  sku                 = var.hub_sku

  tags = {
    Environment = var.environment
  }
}

variable "name" {}
variable "hub_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "type" {}
variable "branch_to_branch_traffic" {}
variable "hub_address_prefix" {}
variable "hub_sku" {}

output "vwan_id" {
  value = azurerm_virtual_wan.vwan.id
}

output "hub_id" {
  value = azurerm_virtual_hub.hub.id
}