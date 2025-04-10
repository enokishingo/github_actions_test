resource "azurerm_container_app_environment" "env" {
  name                           = var.name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  infrastructure_subnet_id       = var.subnet_id
  internal_load_balancer_enabled = var.environment_config.internal_load_balancer_enabled

  workload_profile {
    name                  = var.workload_profile.name
    workload_profile_type = var.workload_profile.workload_profile_type
    minimum_count         = var.workload_profile.minimum_count
    maximum_count         = var.workload_profile.maximum_count
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
variable "environment_config" {
  type = object({
    name                           = string
    infrastructure_subnet_name     = string
    internal_load_balancer_enabled = bool
  })
}
variable "workload_profile" {
  type = object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  })
}

output "environment_id" {
  value = azurerm_container_app_environment.env.id
}