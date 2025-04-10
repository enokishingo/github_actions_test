locals {
  # 基本設定
  environment = "dev"
  location    = "japaneast"
  system_name = "systemb"

  # ネットワーク設定
  address_space = ["10.0.0.0/16"]
  subnet_prefixes = {
    "appgw"              = "10.0.1.0/24"
    "aoai"               = "10.0.2.0/24"
    "system"             = "10.0.3.0/24"
    "vm"                 = "10.0.4.0/24"
    "postgresql"         = "10.0.5.0/24"
    "cosmosdb"           = "10.0.6.0/24"
    "container_apps"     = "10.0.7.0/24"
    "container_registry" = "10.0.8.0/24"
  }

  # OpenAI設定
  openai_sku_name = "S0"

  # Application Gateway設定
  appgw_sku = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  # VM設定
  vm_size           = "Standard_B1ms"
  vm_admin_username = "adminuser"
  vm_os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  vm_source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  # PostgreSQL設定
  postgresql_sku = {
    name     = "B_Standard_B1ms"
    capacity = 1
    tier     = "Burstable"
    family   = "Bust"
  }
  postgresql_version               = "14"
  postgresql_storage_mb            = 32768
  postgresql_backup_retention_days = 7
  postgresql_geo_redundant_backup  = false
  postgresql_charset               = "UTF8"
  postgresql_collation             = "ja_JP.utf8"

  # Cosmos DB設定
  cosmosdb_sku = {
    name     = "Standard"
    capacity = 400
  }
  cosmosdb_consistency_level = "Session"
  cosmosdb_geo_locations = [
    {
      location          = local.location
      failover_priority = 0
    }
  ]
  cosmosdb_backup = {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
  }

  # Container Apps設定
  container_apps_environment = {
    name                           = "env_name"
    infrastructure_subnet_name     = local.resource_names.subnet["container_apps"]
    internal_load_balancer_enabled = true
  }
  container_apps_workload_profile = {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 1
    maximum_count         = 3
  }

  # Container Registry設定
  acr_sku                       = "Premium"
  acr_admin_enabled             = true
  acr_geo_replication_locations = []

  # リソース命名規則
  resource_names = {
    rg   = "rg-${local.system_name}-${local.environment}-${local.location}-001"
    common_rg = "rg-common-${local.environment}-${local.location}-001"
    vnet = "vnet-${local.system_name}-${local.environment}-${local.location}-001"
    subnet = {
      for key in keys(local.subnet_prefixes) :
      key => "snet-${key}-${local.system_name}-${local.environment}-${local.location}-001"
    }
    aoai       = "aoai-${local.system_name}-${local.environment}-${local.location}-001"
    appgw      = "appgw-${local.system_name}-${local.environment}-${local.location}-001"
    vm         = "vm-${local.system_name}-${local.environment}-${local.location}-001"
    postgresql = "psql-${local.system_name}-${local.environment}-${local.location}-001"
    cosmosdb   = "cosmos-${local.system_name}-${local.environment}-${local.location}-001"
    aca        = "aca-${local.system_name}-${local.environment}-${local.location}-001"
    # Container Registryの名前は英数字のみ使用可能
    acr = "acr${local.system_name}${local.environment}${local.location}001"
  }
}