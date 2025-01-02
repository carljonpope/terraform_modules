output "plan" {
  value = [for plan in azurerm_service_plan.app_service_plans :
    { "app_service_plan_name" = plan.name, "app_service_plan_id" = plan.id }
  ]
}
