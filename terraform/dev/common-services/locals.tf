locals {
  # 基本設定
  environment = "dev"
  location    = "japaneast"
  system_name = "common"

  # ネットワーク設定
  address_space = ["10.0.0.0/16"]
  subnet_prefixes = {
    "storage_tfstate"  = "10.0.1.0/24"
    "storage_auditlog" = "10.0.2.0/24"
    "dnspr_inbound"    = "10.0.3.0/24"
    "dnspr_outbound"   = "10.0.4.0/24"
  }

  # Private DNS Zone設定
  private_dns_zones = {
    aoai     = "privatelink.openai.azure.com"
    cosmosdb = "privatelink.mongo.cosmos.azure.com"
    blob     = "privatelink.blob.core.windows.net"
    kv       = "privatelink.vaultcore.azure.net"
    container_registry = "privatelink.azurecr.io"
  }

  # Storage Account設定
  storage_account = {
    account_tier             = "Standard"
    account_replication_type = "GRS"
    min_tls_version          = "TLS1_2"
    enable_https_traffic     = true
  }

  # Entra Domain Services設定
  domain_service = {
    domain_name           = "aadds.contoso.com"
    sku                   = "Standard"
    filtered_sync_enabled = false
  }

  # Virtual WAN設定
  vwan_type                     = "Standard"
  vwan_branch_to_branch_traffic = true
  vwan_hub = {
    address_prefix = "10.1.0.0/16"
    sku            = "Standard"
  }

  # DNS Private Resolver設定
  dnspr_inbound_endpoint = {
    name      = "inbound"
    subnet_id = module.subnet.subnet_ids["dnspr_inbound"]
  }
  dnspr_outbound_endpoint = {
    name      = "outbound"
    subnet_id = module.subnet.subnet_ids["dnspr_outbound"]
  }

  # Log Analytics設定
  log_analytics = {
    sku                        = "PerGB2018"
    retention_in_days          = 30
    internet_ingestion_enabled = false
    internet_query_enabled     = false
  }

  # Key Vault設定
  key_vault = {
    sku_name                    = "standard"
    enabled_for_disk_encryption = true
    purge_protection_enabled    = true
    soft_delete_retention_days  = 7
  }

  # リソース命名規則
  resource_names = {
    rg   = "rg-${local.system_name}-${local.environment}-${local.location}-001"
    vnet = "vnet-${local.system_name}-${local.environment}-${local.location}-001"
    subnet = {
      for key in keys(local.subnet_prefixes) :
      key => "snet-${key}-${local.system_name}-${local.environment}-${local.location}-001"
    }
    dns         = "dns-${local.system_name}-${local.environment}-${local.location}-001"
    vwan        = "vwan-${local.system_name}-${local.environment}-${local.location}-001"
    vwan_hub    = "hub-${local.system_name}-${local.environment}-${local.location}-001"
    dnspr       = "dnspr-${local.system_name}-${local.environment}-${local.location}-001"
    adds        = "adds-${local.system_name}-${local.environment}-${local.location}-001"
    log         = "log-${local.system_name}-${local.environment}-${local.location}-001"
    kv          = "kv-${local.system_name}-${local.environment}-${local.location}-001"
    st_tfstate  = "sttfstatekensho001"
    st_auditlog = "stauditlogkensho001"
  }
}