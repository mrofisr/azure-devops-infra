variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "secret_name" {
  type        = string
  description = "The name of the key vault secret"
}

variable "secret_value" {
  type        = map(string)
  description = "The key vault secret."
  default = {
    "DATABASE_HOST" : "localhost",
    "DATABASE_PORT" : "1433",
    "DATABASE_USER" : "SA",
    "DATABASE_PASS" : "yourStrongPassword#",
    "DATABASE_NAME" : "master",
  }
}
