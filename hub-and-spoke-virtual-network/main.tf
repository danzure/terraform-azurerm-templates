# create a resource group for network infrastructure
resource "azurerm_resource_group" "hubspoke_rg" {
  name     = "rg-${var.hub_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-001"
  location = var.location
  tags     = var.tags
}

# create the hub virtual network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-${var.hub_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-001"
  location            = azurerm_resource_group.hubspoke_rg.location
  resource_group_name = azurerm_resource_group.hubspoke_rg.name
  address_space       = var.hub_vnet_address_space
  tags                = var.tags
}

# create the hub virtual subnet
resource "azurerm_subnet" "hub_snet" {
  name                 = "snet-${var.hub_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-001"
  resource_group_name  = azurerm_resource_group.hubspoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.hub_subnet_address_prefix]
}

# create the Azure Bastion subnet
resource "azurerm_subnet" "bas_hubsnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hubspoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.bas_address_prefix]
}

# create the public IP for the Bastion host
resource "azurerm_public_ip" "bas_pip" {
  name                = "pip-${var.hub_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-001"
  location            = azurerm_resource_group.hubspoke_rg.location
  resource_group_name = azurerm_resource_group.hubspoke_rg.name
  allocation_method   = "Static"
  sku                 = "Standard" # [Standard]
  sku_tier            = var.bas_ip_sku_tier
  tags                = var.tags

  depends_on = [azurerm_subnet.bas_hubsnet]
}

# create a bastion host
resource "azurerm_bastion_host" "hubvnet_bas" {
  name                = "bas-${var.hub_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-001"
  location            = azurerm_resource_group.hubspoke_rg.location
  resource_group_name = azurerm_resource_group.hubspoke_rg.name
  sku                 = var.bas_sku

  ip_configuration {
    name                 = "bas-ip-config"
    subnet_id            = azurerm_subnet.bas_hubsnet.id
    public_ip_address_id = azurerm_public_ip.bas_pip.id
  }

  copy_paste_enabled        = true  # [enabled by default, upgrade to standard to turn this on/off]
  ip_connect_enabled        = false # [upgrade to standard before enabling this setting]
  kerberos_enabled          = false # [upgrade to standard before enabling this setting]
  shareable_link_enabled    = false # [upgrade to standard before enabling this setting]
  session_recording_enabled = false # [upgrade to standard sku to use this feature]
  tags                      = var.tags
}

resource "azurerm_subnet" "fw_hubsnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hubspoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.firewall_address_prefix]
}

resource "azurerm_firewall" "hubvnet_fw" {
  name                = "fw-${var.hub_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-001"
  location            = azurerm_resource_group.hubspoke_rg.location
  resource_group_name = azurerm_resource_group.hubspoke_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku
}

# create one VNET for each number specified in the spoke count variable
resource "azurerm_virtual_network" "spoke_vnet" {
  count               = var.spoke_count
  name                = "vnet-${var.spoke_workload}-${format("%s", local.generate_env_name.envrionment)}-${format("%s", local.generate_loc_name.location)}-${format("%03d", count.index + 1)}"
  location            = azurerm_resource_group.hubspoke_rg.location
  resource_group_name = azurerm_resource_group.hubspoke_rg.name
  address_space       = [cidrsubnet(var.spoke_vnet_address_space_cidr, var.spoke_vnet_new_bits, count.index)]
  tags                = var.tags

  depends_on = [azurerm_virtual_network.hub_vnet]
}