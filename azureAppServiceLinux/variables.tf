variable "name" {
  description = "The name which should be used for this Linux Web App. Changing this forces a new Linux Web App to be created."
}

variable "location" {
  description = "The Azure Region where the Linux Web App should exist. Changing this forces a new Linux Web App to be created."
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the Linux Web App should exist. Changing this forces a new Linux Web App to be created."
}

variable "app_service_plan_id" {
  description = "The ID of the Service Plan that this Linux App Service will be created in."
}

variable "client_affinity_enabled" {
  description = "Should Client Affinity be enabled?"
}

variable "client_certificate_enabled" {
  description = "Should Client Certificates be enabled?"
}

variable "enabled" {
  description = "Should the Linux Web App be enabled? Defaults to true."
}

variable "slot_enabled" {
  description = "Should the Linux Web App be enabled? Defaults to true."
}

variable "https_only" {
  description = "Should the Linux Web App require HTTPS connections."
}

variable "app_settings" {
  description = "A map of key-value pairs of App Settings."
}

variable "auth_settings_enabled" {
  description = "Should the Authentication / Authorization feature be enabled for the Linux Web App?"
}

variable "connection_strings" {
  description = "Connections strings."
}

variable "site_config_ip_restriction" {
  description = "Site Config IP Restriction"
}

variable "site_config_scm_ip_restriction" {
  description = "Site Config SCM IP Restriction"
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Linux Web App. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "tags" {
  description = "A mapping of tags which should be assigned to the Linux Web App."
}

variable "http_logs_retention_days" {
  description = "The retention period in days. A value of 0 means no retention."
}

variable "http_logs_retention_mb" {
  description = "The maximum size in megabytes that log files can use."
}

variable "http_logs_request_tracing" {
  description = "Should failed request tracing be enabled."
}

variable "https_logs_detailed_error_messages" {
  description = "Should detailed error messages be enabled."
}

variable "site_config_always_on" {
  description = "If this Linux Web App is Always On enabled. Defaults to false."
}

variable "app_stack_dotnet_version" {
  description = "The version of .Net to use. Possible values include 3.1, 5.0, and 6.0."
}

variable "app_stack_node_version" {
  description = "The version of Node to run. Possible values include 12-lts, 14-lts, and 16-lts."
}

variable "site_config_managed_pipeline_mode" {
  description = "Managed pipeline mode. Possible values include: Integrated, Classic."
}

variable "site_config_ftps_state" {
  description = "The State of FTP / FTPS service. Possible values include: AllAllowed, FtpsOnly, Disabled."
}

variable "site_config_http2_enabled" {
  description = "Should HTTP2 be enabled?"
}

variable "site_config_websockets_enabled" {
  description = "Should Web Sockets be enabled. Defaults to false."
}

variable "site_config_minimum_tls_version" {
  description = "The configures the minimum version of TLS required for SSL requests. Possible values include: 1.0, 1.1, and 1.2. Defaults to 1.2."
}

variable "site_config_route_all_enabled" {
  description = "Should all outbound traffic have Virtual Network Security Groups and User Defined Routes applied?"
}

variable "site_config_worker_count" {
  description = "The number of Workers for this Linux App Service."
}

variable "public_network_access_enabled" {
  description = "Should public network access be enabled for the Web App"
}

# VNet Integration

variable "vnet_integration_subnet_id" {
  description = "The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)."
}

# Diagnostic Settings
variable "diag_eventhub_name" {
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent. Changing this forces a new resource to be created."
}

variable "diag_eventhub_authorization_rule_id" {
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. Changing this forces a new resource to be created."
}

variable "diag_storage_account_id" {
  description = "The ID of the Storage Account where logs should be sent. Changing this forces a new resource to be created."
}

variable "diag_logsettings" {}
variable "diag_metricsettings" {}

# Private Endpoint

variable "private_endpoint_enabled" {
  description = "Does this resource need a private endpoint?"
}

variable "private_endpoint_location" {
  description = "The supported Azure location where the resource exists. Changing this forces a new resource to be created.."
}

variable "subnet_id" {
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
}

variable "private_dns_zone_ids" {
  description = "Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
}

variable "private_endpoint_tags" {
  description = "A mapping of tags which should be assigned to the private link endpoint"
}

# slot settings

variable "create_slot" {}
variable "app_settings_slot" {}
variable "connection_strings_for_slot" {}

variable "site_config_auto_heal_enabled" {
  default = false
}

variable "auto_heal_settings" {
  default = [
    {
      action_type                    = null
      minimum_process_execution_time = null
      count                          = null
      interval                       = null
      status_code_range              = null
    }
  ]
}

variable "enable_logs" {
  default = true
}

variable "logs" {
  default = [
    {
      dummy = true
    }
  ]
}

variable "app_logging_level_on_filesystem" {
  default = "Warning"
}