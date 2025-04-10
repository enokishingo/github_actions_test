resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_prefixes

  name                 = var.name[each.key]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [each.value]

  service_endpoints = (
    each.key == "aoai" ? ["Microsoft.CognitiveServices"] :
    each.key == "cosmosdb" ? ["Microsoft.AzureCosmosDB"] :
    each.key == "storage_tfstate" ? ["Microsoft.Storage"] :
    each.key == "storage_auditlog" ? ["Microsoft.Storage"] :
    []
  )

  # サブネットに対する委任設定
  dynamic "delegation" {
    for_each = each.key == "postgresql" || each.key == "container_apps" ? [each.key] : []

    content {
      name = "${each.key}-delegation"
      service_delegation {
        name = (
          each.key == "postgresql" ? "Microsoft.DBforPostgreSQL/flexibleServers" :
          each.key == "container_apps" ? "Microsoft.App/environments" :
          ""
        )
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  }
}

variable "name" {}
variable "resource_group_name" {}
variable "vnet_name" {}
variable "environment" {}
variable "location" {}
variable "subnet_prefixes" {}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.subnets : k => v.id }
}