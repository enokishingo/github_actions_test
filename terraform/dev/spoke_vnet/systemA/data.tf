data "azurerm_resource_group" "common" {
  name = local.resource_names.common_rg
}

data "terraform_remote_state" "common" {
  backend = "local"
  config = {
    path = "../../common-services/terraform.tfstate"

    //    tfstateをAzure上で保管する場合は下記のように記載する
    //    backend  = "azurerm"
    //    resource_group_name  = data.azurerm_resource_group.common.name
    //    storage_account_name = "st${local.system_name}${local.environment}${local.location}001"
    //    container_name      = "tfstate"
    //    key                 = "common-services.tfstate"

  }
}