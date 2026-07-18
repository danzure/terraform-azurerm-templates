# create a resource group for network infrastructure
resource "azurerm_resource_group" "network_rg" {
  name     = "rg-${var.network_workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  location = var.location
  tags     = var.network_tags

  lifecycle {
    create_before_destroy = true
  }
}

# create a virtual network (VNET) for network connectivity
resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location

  name          = "vnet-${var.network_workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  address_space = [var.vnet_address_space]
  tags          = var.network_tags
}

# create a virtual subnet (SNET) for the azure virtual desktop
resource "azurerm_subnet" "avd_subnet" {
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  name             = "snet-${var.network_workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  address_prefixes = [var.snet_address_prefix]
}

# create a network security group (NSG) for the azure virtual desktop environment
resource "azurerm_network_security_group" "avd_nsg" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location

  name = "nsg-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  tags = var.avd_tags
}

# associate the Network Security Group (NSG) to the azure virtual desktop subnet
resource "azurerm_subnet_network_security_group_association" "nsg_attach" {
  subnet_id                 = azurerm_subnet.avd_subnet.id
  network_security_group_id = azurerm_network_security_group.avd_nsg.id
}

# create a default rdp rule for the network security group
resource "azurerm_network_security_rule" "nsg_rdp_rule" {
  network_security_group_name = azurerm_network_security_group.avd_nsg.name
  resource_group_name         = azurerm_resource_group.avd_rg.name

  name                       = "AllowHttpsInbound"
  priority                   = "1000"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

# create ip pirefix for NAT Gateway
resource "azurerm_public_ip_prefix" "ngw_ippre" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location

  name = "ippre-ngw-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  tags = var.avd_tags
}

# create a NAT Gateway for outbound internet connectivity
resource "azurerm_nat_gateway" "avd_ngw" {
  resource_group_name = azurerm_resource_group.avd_rg.name
  location            = azurerm_resource_group.avd_rg.location

  name                    = "ngw-${var.workload}-${format("%s", local.generate_env_name.environment)}-${format("%s", local.generate_loc_name.location)}-${var.instance_number}"
  idle_timeout_in_minutes = 10
  tags                    = var.avd_tags
}

# associate the ip prefix to the NAT Gateway
resource "azurerm_nat_gateway_public_ip_prefix_association" "ippre_attach" {
  nat_gateway_id      = azurerm_nat_gateway.avd_ngw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.ngw_ippre.id
}

# associate the NAT Gateway to the azure virtual desktop subnet
resource "azurerm_subnet_nat_gateway_association" "snet_ngw_attach" {
  nat_gateway_id = azurerm_nat_gateway.avd_ngw.id
  subnet_id      = azurerm_subnet.avd_subnet.id
}