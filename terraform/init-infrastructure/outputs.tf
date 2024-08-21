output "resource_group_name" {
  value       = azurerm_resource_group.anglo_rg.name
  description = "The name of the resource group."
}

output "resource_group_location" {
  value       = azurerm_resource_group.anglo_rg.location
  description = "The location of the resource group."
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.anglo_vnet.name
  description = "The name of the virtual network."
}

output "virtual_network_address_space" {
  value       = azurerm_virtual_network.anglo_vnet.address_space
  description = "The address space of the virtual network."
}

output "subnet_names" {
  value       = [for subnet in azurerm_subnet.anglo_subnets : subnet.name]
  description = "The names of the subnets."
}

output "subnet_ids" {
  value       = [for subnet in azurerm_subnet.anglo_subnets : subnet.id]
  description = "The IDs of the subnets."
}

output "network_security_group_name" {
  value       = azurerm_network_security_group.anglo_nsg.name
  description = "The name of the network security group."
}

output "network_security_rules" {
  value = [
    for rule in azurerm_network_security_rule.anglo_nsg_rules : {
      name                       = rule.name
      priority                   = rule.priority
      direction                  = rule.direction
      access                     = rule.access
      protocol                   = rule.protocol
      source_port_range          = rule.source_port_range
      destination_port_range     = rule.destination_port_range
      source_address_prefix      = rule.source_address_prefix
      destination_address_prefix = rule.destination_address_prefix
    }
  ]
  description = "The network security rules."
}
