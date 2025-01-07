resource "azurerm_linux_web_app" "app_service" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = var.app_service_plan_id
  client_affinity_enabled       = var.client_affinity_enabled
  client_certificate_enabled    = var.client_certificate_enabled
  enabled                       = var.enabled
  https_only                    = var.https_only
  app_settings                  = var.app_settings
  tags                          = var.tags
  virtual_network_subnet_id     = var.vnet_integration_subnet_id
  public_network_access_enabled = var.public_network_access_enabled

  lifecycle {
    ignore_changes = [
      tags["CreationDate"],
      logs
    ]
  }

  site_config {
    always_on              = var.site_config_always_on
    managed_pipeline_mode  = var.site_config_managed_pipeline_mode
    ftps_state             = var.site_config_ftps_state
    http2_enabled          = var.site_config_http2_enabled
    websockets_enabled     = var.site_config_websockets_enabled
    minimum_tls_version    = var.site_config_minimum_tls_version
    vnet_route_all_enabled = var.site_config_route_all_enabled
   // auto_heal_enabled      = var.site_config_auto_heal_enabled == true ? var.site_config_auto_heal_enabled : null
    worker_count           = var.site_config_worker_count

    dynamic "auto_heal_setting" {
      for_each = var.site_config_auto_heal_enabled == true ? var.auto_heal_settings : []
      content {
        action {
          action_type                    = auto_heal_setting.value.action_type
          minimum_process_execution_time = auto_heal_setting.value.minimum_process_execution_time
        }
        trigger {
          status_code {
            count             = auto_heal_setting.value.count
            interval          = auto_heal_setting.value.interval
            status_code_range = auto_heal_setting.value.status_code_range
          }
        }
      }
    }

    application_stack {
      dotnet_version = var.app_stack_dotnet_version
      node_version   = var.app_stack_node_version
    }

    dynamic "ip_restriction" {
      for_each = var.site_config_ip_restriction
      content {
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = var.site_config_scm_ip_restriction
      content {
        action                    = scm_ip_restriction.value.action
        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        headers                   = scm_ip_restriction.value.headers
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  identity {
    type = var.identity_type
  }

  dynamic "logs" {
    for_each = var.enable_logs == true ? var.logs : []
    content {
      http_logs {
        file_system {
          retention_in_days = var.http_logs_retention_days
          retention_in_mb   = var.http_logs_retention_mb
        }
      }
      failed_request_tracing  = var.http_logs_request_tracing
      detailed_error_messages = var.https_logs_detailed_error_messages
      application_logs {
        file_system_level = var.app_logging_level_on_filesystem
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                           = "${var.name}-diag"
  target_resource_id             = azurerm_linux_web_app.app_service.id
  eventhub_name                  = var.diag_eventhub_name
  eventhub_authorization_rule_id = var.diag_eventhub_authorization_rule_id
  storage_account_id             = var.diag_storage_account_id

  dynamic "log" {
    for_each = var.diag_logsettings
    content {
      category = log.value.category
      enabled  = log.value.log_enabled
    }
  }
  dynamic "metric" {
    for_each = var.diag_metricsettings
    content {
      category = metric.value.category
      enabled  = metric.value.metric_enabled
    }
  }
  lifecycle {
    ignore_changes = [
      metric,
      log
    ]
  }
}

resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.private_endpoint_enabled == "true" ? 1 : 0
  name                = "${var.name}-pvt_endpoint"
  location            = var.private_endpoint_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.private_endpoint_tags

  lifecycle {
    ignore_changes = [
      tags["CreationDate"]
    ]
  }

  private_service_connection {
    name                           = "${var.name}-pvt_svc_conn"
    private_connection_resource_id = azurerm_linux_web_app.app_service.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.name}-dns_zone_group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}

resource "azurerm_linux_web_app_slot" "app_service_slot" {
  count                     = var.create_slot == "yes" ? 1 : 0
  name                      = "ds01"
  app_service_id            = azurerm_linux_web_app.app_service.id
  client_affinity_enabled   = var.client_affinity_enabled
  enabled                   = var.slot_enabled
  https_only                = var.https_only
  app_settings              = var.app_settings_slot
  tags                      = var.tags
  virtual_network_subnet_id = var.vnet_integration_subnet_id

  lifecycle {
    ignore_changes = [
      tags["CreationDate"]
    ]
  }

  site_config {
    always_on              = var.site_config_always_on
    managed_pipeline_mode  = var.site_config_managed_pipeline_mode
    ftps_state             = var.site_config_ftps_state
    http2_enabled          = var.site_config_http2_enabled
    websockets_enabled     = var.site_config_websockets_enabled
    vnet_route_all_enabled = var.site_config_route_all_enabled

    dynamic "ip_restriction" {
      for_each = var.site_config_ip_restriction
      content {
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
      }
    }


    #ip_restriction = var.site_config_ip_restriction

    application_stack {
      dotnet_version = var.app_stack_dotnet_version
      node_version   = var.app_stack_node_version
    }

  }

  dynamic "connection_string" {
    for_each = var.connection_strings_for_slot
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  identity {
    type = var.identity_type
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = var.http_logs_retention_days
        retention_in_mb   = var.http_logs_retention_mb
      }
    }
  }
}

resource "azurerm_private_endpoint" "slot_private_endpoint" {
  count               = var.create_slot == "yes" ? 1 : 0
  name                = "${var.name}-slot-pvt_endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.private_endpoint_tags

  lifecycle {
    ignore_changes = [
      tags["CreationDate"]
    ]
  }

  private_service_connection {
    name                           = "${var.name}-slot-pvt_svc_conn"
    private_connection_resource_id = azurerm_linux_web_app.app_service.id
    subresource_names              = ["sites-ds01"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.name}-slot-dns_zone_group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  depends_on = [
    azurerm_linux_web_app_slot.app_service_slot
  ]
}