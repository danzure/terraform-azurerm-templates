# Resource Group

resource "azurerm_resource_group" "avd_rg" {
  name     = "rg-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  location = var.location
  tags     = var.avd_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Workspace

resource "azurerm_virtual_desktop_workspace" "avd_vdws" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location
  name                = "vdws-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  friendly_name       = var.workspace_friendly_name
  description         = "${var.workload}-avd-workspace"
  tags                = var.avd_tags

  depends_on = [
    azurerm_resource_group.avd_rg
  ]
}

# Host Pool

resource "azurerm_virtual_desktop_host_pool" "avd_vdpool" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location
  name                = "vdpool-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  friendly_name       = "${var.workload}-hostpool"
  description         = "Hostpool for ${var.workload}"
  tags                = var.avd_tags

  start_vm_on_connect      = true
  validate_environment     = true
  load_balancer_type       = var.host_pool_balancer_type
  type                     = var.host_pool_type
  maximum_sessions_allowed = var.hostpool_max_sessions
  preferred_app_group_type = "Desktop"

  scheduled_agent_updates {
    enabled = true
    schedule {
      day_of_week = "Sunday"
      hour_of_day = 3
    }
  }

  depends_on = [
    azurerm_resource_group.avd_rg
  ]
}

# Host Pool Registration Info

resource "azurerm_virtual_desktop_host_pool_registration_info" "vdpool_registration" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd_vdpool.id
  expiration_date = var.rfc3339time

  depends_on = [
    azurerm_virtual_desktop_host_pool.avd_vdpool
  ]
}

# Application Group (DAG)

resource "azurerm_virtual_desktop_application_group" "avd_dag" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location
  host_pool_id        = azurerm_virtual_desktop_host_pool.avd_vdpool.id
  name                = "vdag-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  friendly_name       = "${var.workload}-Desktop"
  description         = "${var.workload} Desktop Application Group"
  type                = "Desktop"
  tags                = var.avd_tags

  depends_on = [
    azurerm_virtual_desktop_host_pool.avd_vdpool,
    azurerm_resource_group.avd_rg
  ]
}

# Workspace and Application Group Association

resource "azurerm_virtual_desktop_workspace_application_group_association" "vdws_dag_associate" {
  workspace_id         = azurerm_virtual_desktop_workspace.avd_vdws.id
  application_group_id = azurerm_virtual_desktop_application_group.avd_dag.id

  depends_on = [
    azurerm_virtual_desktop_workspace.avd_vdws,
    azurerm_virtual_desktop_application_group.avd_dag
  ]
}