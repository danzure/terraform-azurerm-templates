# output the name of the resource group
output "rg_name" {
  description = "Output the name of the AVD resource group"
  value       = azurerm_resource_group.avd_rg.name
}

output "production_level_output" {
  description = "Outputs the production level for the deployment [prod, uat, dev]"
  value       = var.environment
}

output "location_output" {
  description = "Outputs the location for the deployment"
  value       = var.location
}

output "vdpool_name_output" {
  description = "Outputs the name of the avd host pool"
  value       = azurerm_virtual_desktop_host_pool.avd_vdpool.name
}

output "vpool_id_output" {
  description = "Outputs the id of the hostpool"
  value       = azurerm_virtual_desktop_host_pool.avd_vdpool.id
}

output "vdws_name_output" {
  description = "Outputs the name of the avd workspace"
  value       = azurerm_virtual_desktop_workspace.avd_vdws.name
}

output "vdws_id_output" {
  description = "Outputs the id of the virtual desktop workspace"
  value       = azurerm_virtual_desktop_workspace.avd_vdws.id
}

output "vdag_name_output" {
  description = "Outputs the name of the virtual desktop application group (dag)"
  value       = azurerm_virtual_desktop_application_group.avd_dag.name
}

output "vnet_address_space" {
  description = "Outputs the ip address range for the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "snet_address_prefix" {
  description = "Outputs the address space for the virtual subnet"
  value       = azurerm_subnet.avd_subnet.address_prefixes
}

output "rd_host_count" {
  description = "Outputs the number of remote desktop hosts to be deployed"
  value       = var.rdsh_count
}

output "profile_storage_share" {
  description = "Outputs the of the storage account for FSLogix profiles"
  value       = azurerm_storage_account.sa_fslogix.name
}

output "resource_tags" {
  description = "Outputs the tags that will be applied to the avd resources"
  value       = var.avd_tags
}

output "workspace_friendly_name" {
  description = "Outputs the friendly name for the avd workspace"
  value       = azurerm_virtual_desktop_workspace.avd_vdws.friendly_name
}