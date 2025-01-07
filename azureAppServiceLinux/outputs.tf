output "app_service_id" {
  value = azurerm_linux_web_app.app_service.id
}

output "app_service_principal_id" {
  value = azurerm_linux_web_app.app_service.identity[0].principal_id
}

output "app_service_slot_principal_id" {
  value = azurerm_linux_web_app_slot.app_service_slot[0].identity[0].principal_id
}