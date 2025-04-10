resource "azurerm_resource_group" "rg" {
  name     = local.resource_names.rg
  location = local.location
  tags = {
    Environment = local.environment
  }
}

module "vnet" {
  source              = "../../../modules/vnet"
  name                = local.resource_names.vnet
  resource_group_name = local.resource_names.rg
  environment         = local.environment
  location            = local.location
  address_space       = local.address_space
}

module "subnet" {
  source              = "../../../modules/subnet"
  name                = local.resource_names.subnet
  resource_group_name = local.resource_names.rg
  vnet_name           = module.vnet.vnet_name
  environment         = local.environment
  location            = local.location
  subnet_prefixes     = local.subnet_prefixes
}

module "openai" {
  source              = "../../../modules/openai"
  name                = local.resource_names.aoai
  resource_group_name = local.resource_names.rg
  location            = local.location
  environment         = local.environment
  sku_name            = local.openai_sku_name
  subnet_id           = module.subnet.subnet_ids["aoai"]
  domain              = local.resource_names.aoai
}

module "appgw" {
  source              = "../../../modules/appgw"
  name                = local.resource_names.appgw
  resource_group_name = local.resource_names.rg
  location            = local.location
  environment         = local.environment
  subnet_id           = module.subnet.subnet_ids["appgw"]
  sku                 = local.appgw_sku
}

module "vm" {
  source                 = "../../../modules/vm"
  name                   = local.resource_names.vm
  resource_group_name    = local.resource_names.rg
  location               = local.location
  environment            = local.environment
  subnet_id              = module.subnet.subnet_ids["vm"]
  vm_size                = local.vm_size
  os_disk                = local.vm_os_disk
  source_image_reference = local.vm_source_image_reference
  admin_username         = local.vm_admin_username
  admin_password         = var.vm_admin_password
}

module "postgresql" {
  source                = "../../../modules/postgresql"
  name                  = local.resource_names.postgresql
  resource_group_name   = local.resource_names.rg
  location              = local.location
  environment           = local.environment
  vnet_id               = module.vnet.vnet_id
  subnet_id             = module.subnet.subnet_ids["postgresql"]
  sku                   = local.postgresql_sku
  postgresql_version    = local.postgresql_version
  storage_mb            = local.postgresql_storage_mb
  backup_retention_days = local.postgresql_backup_retention_days
  geo_redundant_backup  = local.postgresql_geo_redundant_backup
  charset               = local.postgresql_charset
  collation             = local.postgresql_collation
  admin_password        = var.postgresql_admin_password
}

module "cosmosdb" {
  source              = "../../../modules/cosmosdb"
  name                = local.resource_names.cosmosdb
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  environment         = local.environment
  subnet_id           = module.subnet.subnet_ids["cosmosdb"]
  sku                 = local.cosmosdb_sku
  consistency_level   = local.cosmosdb_consistency_level
  geo_locations       = local.cosmosdb_geo_locations
  backup              = local.cosmosdb_backup
}

module "container_apps" {
  source              = "../../../modules/container_apps"
  name                = local.resource_names.aca
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  environment         = local.environment
  subnet_id           = module.subnet.subnet_ids["container_apps"]
  environment_config  = local.container_apps_environment
  workload_profile    = local.container_apps_workload_profile
}

module "container_registry" {
  source              = "../../../modules/container_registry"
  name                = local.resource_names.acr
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  environment         = local.environment
  subnet_id           = module.subnet.subnet_ids["container_registry"]
  private_dns_zone_id = data.terraform_remote_state.common.outputs.private_dns_zone_ids["container_registry"]
  sku                = local.acr_sku
  admin_enabled       = local.acr_admin_enabled
  geo_replications    = local.acr_geo_replication_locations
}