# deploy log analytics workspace 
resource "azurerm_log_analytics_workspace" "log_analytics" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location

  name              = "log-${format("%s", local.generate_env_name.environment)}-${var.workload}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  retention_in_days = var.log_analytics_retention
  sku               = var.log_analytics_sku
  tags              = var.avd_tags

  depends_on = [azurerm_resource_group.avd_rg]
}