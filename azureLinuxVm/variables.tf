variable "name" {}
variable "resource_group" {}
variable "location" {}


## nic
variable "subnet_id" {}
variable "network_ip_address_allocation" {}
variable "network_private_ip" {}

## ssh key
variable "linuxvm_pubkey" {}
variable "linuxvm_pubkey_rg" {}

## vm
variable "vm_size" {}
variable "admin_user" {}
variable "user" {}
variable "caching" {}
variable "os_disk_type" {}
variable "license_type" {}
variable "extensions_time_budget" {}
variable "write_accelerator_enabled" {}
variable "availability_set_id" {}
variable "identity_type" {}
variable "encryption_at_host_enabled" {
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
}

variable "shared_image_version" {}
variable "shared_image_name" {}
variable "image_gallery_name" {}
variable "image_gallery_rg" {}

variable "image_sku" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "tags" {}
variable "vmtags" {}

## disk variables

variable "data_disk_storage_account_type" {}
variable "data_disk_create_option" {}
variable "data_disk_size_gb" {}
variable "data_disk_lun" {}
variable "data_disk_caching" {}
variable "data_disk_tier" {}
variable "data_disk_on_demand_bursting_enabled" {}

## role assignment variables

variable "vm_azure_role_definition_name" {}

## backup variables

variable "vm_vault_policy_id" {}
variable "recovery_vault_rg_name" {}
variable "vm_vault_name" {}
variable "enable_backup" {}

## computer name

variable "computer_name" {}