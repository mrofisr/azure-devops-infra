variable "resource_group_location" {
  type        = string
  default     = "southeastasia"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., 'dev', 'pre-prod', 'prod')."
  default     = "dev"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network."
  default     = "main-vnet"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "Address space that is used the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = list(string)
    tags           = map(string)
  }))
  description = "List of subnets."
  default = [
    {
      name           = "dev-subnet"
      address_prefix = ["10.0.1.0/24"]
      tags = {
        "environment" = "dev"
      }
    }
  ]
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the network security group."
  default     = "main-nsg"
}

variable "network_security_group_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of network security group rules."
  default = [
    {
      name                       = "allow-ping"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-ssh"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-http"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "80"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-https"
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "443"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-mssql"
      priority                   = 1004
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "1433"
      source_port_range          = "*"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "10.0.0.0/16"
    }
  ]
}
