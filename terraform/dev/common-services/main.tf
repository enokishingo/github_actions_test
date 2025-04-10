resource "azurerm_resource_group" "rg" {
  name     = local.resource_names.rg
  location = local.location
  tags = {
    Environment = local.environment
  }
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = local.resource_names.vnet
  resource_group_name = local.resource_names.rg
  environment         = local.environment
  location            = local.location
  address_space       = local.address_space
}

module "subnet" {
  source              = "../../modules/subnet"
  name                = local.resource_names.subnet
  resource_group_name = local.resource_names.rg
  vnet_name           = module.vnet.vnet_name
  environment         = local.environment
  location            = local.location
  subnet_prefixes     = local.subnet_prefixes
}

module "private_dns" {
  source              = "../../modules/private_dns"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = local.environment
  vnet_id             = module.vnet.vnet_id
  zones               = local.private_dns_zones
}

module "storage_tfstate" {
  source                   = "../../modules/storage"
  name                     = local.resource_names.st_tfstate
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = local.location
  environment              = local.environment
  subnet_id                = module.subnet.subnet_ids["storage_tfstate"]
  private_dns_zone_id      = module.private_dns.zone_ids["blob"]
  account_tier             = local.storage_account.account_tier
  account_replication_type = local.storage_account.account_replication_type
  min_tls_version          = local.storage_account.min_tls_version
  enable_https_traffic     = local.storage_account.enable_https_traffic
}

module "storage_auditlog" {
  source                   = "../../modules/storage"
  name                     = local.resource_names.st_auditlog
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = local.location
  environment              = local.environment
  subnet_id                = module.subnet.subnet_ids["storage_auditlog"]
  private_dns_zone_id      = module.private_dns.zone_ids["blob"]
  account_tier             = local.storage_account.account_tier
  account_replication_type = local.storage_account.account_replication_type
  min_tls_version          = local.storage_account.min_tls_version
  enable_https_traffic     = local.storage_account.enable_https_traffic
}

//module "domain_service" {
//  source                = "../../modules/adds"
//  name                  = local.resource_names.adds
//  resource_group_name   = azurerm_resource_group.rg.name
//  location              = local.location
//  environment           = local.environment
//  subnet_id             = module.subnet.subnet_ids["adds"]
//  domain_name           = local.adds.domain_name
//  sku                   = local.adds.sku
//  filtered_sync_enabled = local.adds.filtered_sync_enabled
//}
//
//module "vwan" {
//  source                   = "../../modules/vwan"
//  name                     = local.resource_names.vwan
//  hub_name                 = local.resource_names.vwan_hub
//  resource_group_name      = azurerm_resource_group.rg.name
//  location                 = local.location
//  environment              = local.environment
//  type                     = local.vwan_type
//  branch_to_branch_traffic = local.vwan_branch_to_branch_traffic
//  hub_address_prefix       = local.vwan_hub.address_prefix
//  hub_sku                  = local.vwan_hub.sku
//}
//
//module "dnspr" {
//  source              = "../../modules/dnspr"
//  name                = local.resource_names.dnspr
//  resource_group_name = azurerm_resource_group.rg.name
//  location            = local.location
//  environment         = local.environment
//  vnet_id             = module.vnet.vnet_id
//  inbound_endpoint    = local.dnspr_inbound_endpoint
//  outbound_endpoint   = local.dnspr_outbound_endpoint
//}
//
//module "log" {
//  source                     = "../../modules/log"
//  name                       = local.resource_names.log
//  resource_group_name        = azurerm_resource_group.rg.name
//  location                   = local.location
//  environment                = local.environment
//  sku                        = local.log_analytics.sku
//  retention_in_days          = local.log_analytics.retention_in_days
//  internet_ingestion_enabled = local.log_analytics.internet_ingestion_enabled
//  internet_query_enabled     = local.log_analytics.internet_query_enabled
//}
//
//module "keyvault" {
//  source                      = "../../modules/kv"
//  name                        = local.resource_names.keyvault
//  resource_group_name         = azurerm_resource_group.rg.name
//  location                    = local.location
//  environment                 = local.environment
//  subnet_id                   = module.subnet.subnet_ids["keyvault"]
//  sku_name                    = local.key_vault.sku_name
//  enabled_for_disk_encryption = local.key_vault.enabled_for_disk_encryption
//  purge_protection_enabled    = local.key_vault.purge_protection_enabled
//  soft_delete_retention_days  = local.key_vault.soft_delete_retention_days
//}