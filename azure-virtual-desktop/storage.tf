# Create random storage account number
resource "random_string" "sa_random_string" {
  length  = 6
  special = false
  upper   = false
  numeric = true
  lower   = false
}

# Create the storage account for FSLogix profiles
resource "azurerm_storage_account" "sa_fslogix" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location

  name                     = "safslogix${random_string.sa_random_string.id}"
  account_replication_type = "LRS"
  account_tier             = "Premium"
  account_kind             = "FileStorage"

  tags = var.storage_account_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_storage_share" "fs_fslogix" {
  name               = "fslx-profile"
  storage_account_id = azurerm_storage_account.sa_fslogix.id
  quota              = tonumber(var.fsl_quota)

  lifecycle {
    prevent_destroy = false
  }
}