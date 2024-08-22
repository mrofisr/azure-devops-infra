variable "resource_group_location" {
  type        = string
  description = "Location for all resources."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the SQL Database."
  default     = "myResourceGroup"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to associate with the SQL logical server."
}

variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "SampleDB"
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
  }
}
