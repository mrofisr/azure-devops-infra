resource "azurerm_resource_group" "anglo_rg" {
  name     = "${var.resource_group_name_prefix}-${var.environment}"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "anglo_vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.anglo_rg.name
  location            = azurerm_resource_group.anglo_rg.location
  address_space       = var.virtual_network_address_space
  depends_on          = [azurerm_resource_group.anglo_rg]
}

resource "azurerm_subnet" "anglo_subnets" {
  for_each             = { for subnet in var.subnets : subnet.name => subnet }
  name                 = each.value.name
  address_prefixes     = each.value.address_prefix
  resource_group_name  = azurerm_resource_group.anglo_rg.name
  virtual_network_name = azurerm_virtual_network.anglo_vnet.name
  depends_on           = [azurerm_virtual_network.anglo_vnet]
}

resource "azurerm_network_security_group" "anglo_nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.anglo_rg.location
  resource_group_name = azurerm_resource_group.anglo_rg.name
  depends_on          = [azurerm_resource_group.anglo_rg]
}

resource "azurerm_network_security_rule" "anglo_nsg_rules" {
  for_each                    = { for rule in var.network_security_group_rules : rule.name => rule }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.anglo_rg.name
  network_security_group_name = azurerm_network_security_group.anglo_nsg.name
  depends_on                  = [azurerm_network_security_group.anglo_nsg]
}
