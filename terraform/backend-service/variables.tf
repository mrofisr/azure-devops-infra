variable "app_name" {
  type    = string
  default = "The name of the application"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
  }
}

variable "app_service_plan_name" {
  type    = string
  default = "The name of the service plan"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "The ID of the subnet to deploy the web app."
}
