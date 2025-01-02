resource "azurerm_network_interface" "linuxvm_network_interface" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.network_ip_address_allocation
    private_ip_address            = var.network_private_ip
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags["creationDate"]
    ]
  }
}

data "azurerm_subscription" "primary" {
}

data "azurerm_ssh_public_key" "linuxvm_pub_key" {
  name                = var.linuxvm_pubkey
  resource_group_name = var.linuxvm_pubkey_rg
}

data "azurerm_shared_image_version" "shared_image" {
  name                = var.shared_image_version
  image_name          = var.shared_image_name
  gallery_name        = var.image_gallery_name
  resource_group_name = var.image_gallery_rg
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                       = var.name
  resource_group_name        = var.resource_group
  location                   = var.location
  size                       = var.vm_size
  admin_username             = var.admin_user
  availability_set_id        = var.availability_set_id
  encryption_at_host_enabled = var.encryption_at_host_enabled

  network_interface_ids = [
    azurerm_network_interface.linuxvm_network_interface.id,
  ]

  admin_ssh_key {
    username   = var.user
    public_key = data.azurerm_ssh_public_key.linuxvm_pub_key.public_key
  }

  os_disk {
    caching                   = var.caching
    storage_account_type      = var.os_disk_type
    write_accelerator_enabled = var.write_accelerator_enabled
  }

  identity {
    type = var.identity_type
  }

  plan {
    name      = var.image_sku
    publisher = var.image_publisher
    product   = var.image_offer
  }
  source_image_id = data.azurerm_shared_image_version.shared_image.id
  tags            = var.vmtags

  license_type           = var.license_type
  extensions_time_budget = var.extensions_time_budget

  computer_name = var.computer_name

  lifecycle {
    ignore_changes = [
      tags["creationDate"]
    ]
  }
}

resource "azurerm_managed_disk" "disk" {
  name                       = "${var.name}-disk"
  location                   = var.location
  resource_group_name        = var.resource_group
  storage_account_type       = var.data_disk_storage_account_type
  create_option              = var.data_disk_create_option
  disk_size_gb               = var.data_disk_size_gb
  tier                       = var.data_disk_tier
  on_demand_bursting_enabled = var.data_disk_on_demand_bursting_enabled
  tags                       = var.tags

  lifecycle {
    ignore_changes = [
      tags["creationDate"]
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linuxvm.id
  lun                = var.data_disk_lun
  caching            = var.data_disk_caching
}

resource "azurerm_role_assignment" "vm_reader_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.vm_azure_role_definition_name
  principal_id         = azurerm_linux_virtual_machine.linuxvm.identity[0].principal_id
}



resource "azurerm_backup_protected_vm" "vm_backup" {
  count               = var.enable_backup
  resource_group_name = var.recovery_vault_rg_name
  recovery_vault_name = var.vm_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.linuxvm.id
  backup_policy_id    = var.vm_vault_policy_id

  lifecycle {
    ignore_changes = [
      resource_group_name,
      source_vm_id
    ]
  }
}