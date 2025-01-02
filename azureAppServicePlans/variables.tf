variable "name_prefix" {
  description = "The name which should be used for this App Service Plan."
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the App Service Plan."
}
variable "location" {
  description = "The Azure Region where the Service Plan should exist."
}
variable "tags" {
  description = "The resource tags that will be applied to the resource."
}

variable "service_plans" {}