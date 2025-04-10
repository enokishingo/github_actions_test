resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.name
  computer_name       = substr(replace(var.name, "-", ""), 0, 15)
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
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
variable "vm_size" {}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
variable "os_disk" {
  type = object({
    caching              = string
    storage_account_type = string
  })
}
variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.vm.id
}