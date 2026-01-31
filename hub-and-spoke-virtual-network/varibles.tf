variable "bas_address_prefix" {
  description = "The CIDR block for the Azure Bastion subnet (AzureBastionSubnet). Must be /26 as per Azure requirements."
  type        = string
  default     = "10.0.0.192/26"
}

variable "bas_sku" {
  description = "The Azure bastion SKU used for the hub virtual network"
  type = string
  default = "Standard" # [Basic, Standard, Premium]
}

variable "bas_ip_sku_tier" {
  description = "value"
  type = string
  default = "Regional" # [Regional, Global]
}

variable "environment" {
  description = "The deployment environment (e.g., 'development', 'staging', 'production'). This value is used in resource naming conventions and may be abbreviated (e.g., 'development' to 'dev' - see locals.tf for specific abbreviation logic)."
  type        = string
  default     = "development"
}

variable "firewall_address_prefix" {
  description = "The CIDR block for the Azure Firewall subnet (AzureFirewallSubnet). Must be /26 as per Azure requirements."
  type        = string
  default     = "10.0.0.128/26"
}

variable "firewall_sku" {
  description = "The SKU of Azure firewall to be deployed to the hub virtual network"
  type = string
  default = "Basic" #[Basic, Standard, Premium]
}

variable "hub_subnet_address_prefix" {
  description = "The CIDR block for the primary subnet within the Hub Virtual Network (e.g., a subnet for shared services or gateway)."
  type        = string
  default     = "10.0.1.0/24"
}

variable "hub_vnet_address_space" {
  description = "A list of CIDR blocks defining the address space for the Hub Virtual Network (e.g., [\"10.0.0.0/16\"])."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub_workload" {
  description = "A descriptive name or identifier for the Hub Virtual Network (e.g., 'hub', 'shared'). This is often used as a component in resource naming for hub-specific resources."
  type        = string
  default     = "hub"
}

variable "location" {
  description = "The Azure region where the resources will be deployed (e.g., 'uksouth', 'eastus'). This value is used in resource naming and may be abbreviated (e.g., 'uksouth' to 'uks' - see locals.tf for specific abbreviation logic)."
  type        = string
  default     = "uksouth"
}

variable "spoke_count" {
  description = "The number of spoke Virtual Networks to create and peer with the Hub VNet."
  type        = number
  default     = 3 # Number of spokes to deploy
  validation {
    condition     = var.spoke_count >= 0
    error_message = "The number of spokes must be zero or a positive integer."
  }
}

variable "spoke_subnet_new_bits" {
  description = "Number of additional bits to extend the prefix of each Spoke VNet's address space for its default subnet. For example, if a Spoke VNet is /24 and new_bits is 1, its default subnet will be /25."
  type        = number
  default     = 1 // Creates /25 subnets from the /24 spoke VNets (24 + 1 = 25)
}

variable "spoke_vnet_address_space_cidr" {
  description = "The foundational CIDR block (e.g., '10.1.0.0/16') from which individual Spoke Virtual Network address spaces will be calculated using 'spoke_vnet_new_bits'."
  type        = string
  default     = "10.1.0.0/16"
  validation {
    condition     = tonumber(split("/", var.spoke_vnet_address_space_cidr)[1]) >= 1 && tonumber(split("/", var.spoke_vnet_address_space_cidr)[1]) <= 31
    error_message = "The base address space must have a valid CIDR prefix length (1-31)."
  }
}

variable "spoke_vnet_new_bits" {
  description = "Number of additional bits to extend the prefix of 'spoke_vnet_address_space_cidr' for each Spoke VNet. For example, if base is /16 and new_bits is 8, each spoke VNet will be a /24."
  type        = number
  default     = 8 // Creates /24 networks from the /16 base (16 + 8 = 24)
}

variable "spoke_workload" {
  description = "A descriptive name or identifier for the Spoke Virtual Networks (e.g., 'app', 'data'). This is often used as a component in resource naming for spoke-specific resources."
  type        = string
  default     = "spoke"
}

variable "tags" {
  description = "A map of tags to apply to all created Azure resources. These tags help in organizing and managing resources."
  type        = map(string)
  default = {
    Deployment    = "Terraform"
    Workload      = "hubspoke"
    Envrionment   = "Development"
    CostCentre    = "Infrastructure"
    ResourceOwner = "Username"
  }
}

variable "workload" {
  description = "A descriptive name for the overall workload or application stack being deployed (e.g., 'spoke', 'services'). This names the resource group"
  type        = string
  default     = "hubspoke"
}