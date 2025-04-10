variable "vm_admin_password" {
  description = "The administrator password for the VM server"
  type        = string
  sensitive   = true
}

variable "postgresql_admin_password" {
  description = "The administrator password for the PostgreSQL server"
  type        = string
  sensitive   = true
}