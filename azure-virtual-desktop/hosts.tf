# Local Values

locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.vdpool_registration.token
}

# Network Interface(s)

resource "azurerm_network_interface" "host_nic" {
  count               = var.rdsh_count
  name                = format("nic-${var.prefix}-host-%03d", count.index + 1)
  location            = azurerm_resource_group.avd_rg.location
  resource_group_name = azurerm_resource_group.avd_rg.name

  ip_configuration {
    name                          = "nic-${count.index + 1}_config"
    subnet_id                     = azurerm_subnet.avd_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_resource_group.avd_rg,
    azurerm_subnet.avd_subnet
  ]
}

# Virtual Machine Host(s)

resource "azurerm_windows_virtual_machine" "avd_host" {
  count                 = var.rdsh_count
  name                  = format("${var.prefix}-host-%03d", count.index + 1)
  location              = azurerm_resource_group.avd_rg.location
  resource_group_name   = azurerm_resource_group.avd_rg.name
  network_interface_ids = [azurerm_network_interface.host_nic.*.id[count.index]]
  size                  = var.vm_size
  provision_vm_agent    = true
  automatic_updates_enabled = false
  patch_assessment_mode = "ImageDefault"
  patch_mode            = var.host_patch_mode

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    name                 = format("osdisk-${var.prefix}-host-%03d", count.index + 1)
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.host_disk_size
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-25h2-avd"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.host_nic
  ]
}

# VM Extension: AVD Host Pool Registration

resource "azurerm_virtual_machine_extension" "avd_host_registration" {
  count                      = var.rdsh_count
  name                       = format("hostregistration-${var.prefix}-host-%03d", count.index + 1)
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_host.*.id[count.index]
  publisher                  = "Microsoft.PowerShell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "modulesUrl": "${var.avd_registration_modules_url}",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName": "${azurerm_virtual_desktop_host_pool.avd_vdpool.name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "properties": {
        "registrationInfoToken": "${local.registration_token}"
      }
    }
PROTECTED_SETTINGS
}

# VM Extension: Domain Join

resource "azurerm_virtual_machine_extension" "domain_join" {
  count                       = var.rdsh_count
  name                        = format("domainjoin-${var.prefix}-host-%03d", count.index + 1)
  virtual_machine_id          = azurerm_windows_virtual_machine.avd_host.*.id[count.index]
  publisher                   = "Microsoft.Compute"
  type                        = "JsonADDomainExtension"
  type_handler_version        = "1.3"
  automatic_upgrade_enabled   = true
  failure_suppression_enabled = true

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.domain_ou_path}",
      "User": "${var.domain_join_upn}@${var.domain_name}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_password}"
    }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_windows_virtual_machine.avd_host
  ]
}