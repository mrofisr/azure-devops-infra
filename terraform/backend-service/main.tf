resource "azurerm_service_plan" "service_plan" {
  name                   = var.app_name
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  os_type                = "Linux"
  sku_name               = "S1"
  worker_count           = 1
  zone_balancing_enabled = true
  tags                   = var.tags
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = azurerm_service_plan.service_plan.name
  target_resource_id  = azurerm_service_plan.service_plan.id
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  depends_on          = [azurerm_service_plan.service_plan]
  profile {
    name = "Scale out condition"
    capacity {
      default = 1
      minimum = 1
      maximum = 5
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.service_plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 60
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.service_plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 20
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }
  }
}

resource "azurerm_linux_web_app" "web_app" {
  name                      = var.app_name
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  service_plan_id           = azurerm_service_plan.service_plan.id
  virtual_network_subnet_id = var.virtual_network_subnet_id
  depends_on                = [azurerm_service_plan.service_plan]
  app_settings = {
    "DOCKER_REGISTRY_SERVER_USERNAME" = "false"
    "DOCKER_REGISTRY_SERVER_URL"      = "false"
    "DOCKER_REGISTRY_SERVER_PASSWORD" = "false"
  }
  site_config {
    always_on           = true
    load_balancing_mode = "WeightedRoundRobin"
    application_stack {
      docker_image     = "gcr.io/mrofisr/go-rest-api"
      docker_image_tag = "latest"
    }
    health_check_path                 = "/ping"
    health_check_eviction_time_in_min = 10
  }
  logs {
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs {
      file_system {
        retention_in_days = 3
        retention_in_mb   = 50
      }
    }
  }
}
