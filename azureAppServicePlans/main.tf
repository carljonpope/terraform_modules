resource "azurerm_service_plan" "service_plans" {
  for_each                      = var.service_plans
  name                          = "${var.name_prefix}${format("%02d", each.value.index)}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  os_type                       = each.value.os_type
  sku_name                      = each.value.sku_name
  maximum_elastic_worker_count  = "${replace(each.value.sku_name, "EP", "") != each.value.sku_name}" ? each.value.maximum_elastic_worker_count : null
  worker_count                  = each.value.worker_count
  per_site_scaling_enabled      = each.value.per_site_scaling_enabled
  tags                          = var.tags

  lifecycle {
    ignore_changes = [
      tags["creationDate"]
    ]
  }
}