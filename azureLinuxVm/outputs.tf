output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.linuxvm.id
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.linuxvm.name
}

output "virtual_machine_managed_id" {
  value = azurerm_linux_virtual_machine.linuxvm.identity[0].principal_id
}