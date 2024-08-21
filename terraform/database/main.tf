resource "random_pet" "azurerm_mssql_server_name" {
  prefix = "dev-sql-server"
}

resource "random_password" "admin_password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = try(random_password.admin_password[0].result, var.admin_password)
}

resource "azurerm_mssql_server" "server" {
  name                         = random_pet.azurerm_mssql_server_name.id
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "db" {
  name           = var.sql_db_name
  server_id      = azurerm_mssql_server.server.id
  sku_name       = "Basic"
  zone_redundant = true
  max_size_gb    = 1
  depends_on     = [azurerm_mssql_server.server]
}
