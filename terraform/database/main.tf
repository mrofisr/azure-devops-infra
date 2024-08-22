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
  name                          = random_pet.azurerm_mssql_server_name.id
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  administrator_login           = var.admin_username
  administrator_login_password  = local.admin_password
  version                       = "12.0"
  tags                          = var.tags
  public_network_access_enabled = true
}

resource "azurerm_mssql_database" "db" {
  name        = var.sql_db_name
  server_id   = azurerm_mssql_server.server.id
  sku_name    = "Basic"
  max_size_gb = 1
  read_scale  = false
  depends_on  = [azurerm_mssql_server.server]
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
  depends_on       = [azurerm_mssql_server.server]
}

resource "azurerm_mssql_virtual_network_rule" "vnet_rule" {
  name       = "AllowVnet"
  server_id  = azurerm_mssql_server.server.id
  subnet_id  = var.subnet_id
  depends_on = [azurerm_mssql_server.server]
}
