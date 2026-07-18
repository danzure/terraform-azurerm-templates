variable "admin_password" {
  description = "Specifies the password for the local administrator account on session hosts."
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}

variable "admin_username" {
  description = "Specifies the username for the local administrator account on session hosts."
  type        = string
  default     = "azureadmin"
}

variable "avd_host_registration" {
  description = "URL for the PowerShell DSC configuration ZIP file used for AVD host registration."
  type        = string
  default     = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_02-23-2022.zip"
}

variable "avd_registration_modules_url" {
  description = "URL for the DSC modules ZIP file required for AVD host registration."
  type        = string
  default     = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
}

variable "avd_tags" {
  description = "Tags applied to all Azure Virtual Desktop resources."
  default = {
    Deployment  = "Terraform"
    Workload    = "AVD"
    Environment = "Development"
  }
}

variable "domain_join_upn" {
  description = "Username (without domain) for the account used to join session hosts to Active Directory."
  type        = string
  default     = "domainjoinuser"
}

variable "domain_name" {
  description = "Active Directory domain name for joining session hosts."
  type        = string
  default     = "hosts.local"
}

variable "domain_ou_path" {
  description = "Distinguished Name (DN) of the Organizational Unit for joining hosts in Active Directory."
  type        = string
  default     = ""
}

variable "domain_password" {
  description = "Password for the domain join account used during Active Directory join."
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment for resources (e.g., dev, uat, prod)."
  type        = string
  default     = "dev"
}

variable "fsl_quota" {
  description = "Storage quota in GB for the FSLogix file share."
  type        = number
  default     = 100

  validation {
    condition     = var.fsl_quota >= 100
    error_message = "The FSLogix share quota must be at least 100 GB for Premium FileStorage accounts."
  }
}

variable "host_disk_size" {
  description = "OS disk size in GB for session hosts."
  type        = string
  default     = "128"
}

variable "host_patch_mode" {
  description = "Specifies the patching mode for session hosts: Manual, AutomaticByOS, or AutomaticByPlatform."
  default     = "Manual"
}

variable "host_pool_balancer_type" {
  description = "Load balancer type for the host pool (e.g., DepthFirst, BreadthFirst)."
  default     = "DepthFirst"
}

variable "host_pool_type" {
  description = "Type of host pool (e.g., Pooled, Personal)."
  default     = "Pooled"
}

variable "hostpool_max_sessions" {
  description = "Maximum number of user sessions allowed per session host."
  default     = "5"
}

variable "instance_number" {
  description = "Instance number appended to resource names for uniqueness."
  type        = string
  default     = "001"
}

variable "location" {
  description = "Azure region for resource deployment (e.g., uksouth, eastus)."
  type        = string
  default     = "uksouth"
}

variable "log_analytics_retention" {
  description = "Retention period in days for Log Analytics workspace data."
  default     = "30"
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics workspace (e.g., PerGB2018, Premium, Standard)."
  default     = "PerGB2018"
}

variable "network_tags" {
  description = "Tags applied to network infrastructure resources."
  default = {
    Deployment  = "Terraform"
    Workload    = "Infrastructure"
    Environment = "Development"
  }
}

variable "network_workload" {
  description = "Workload or application name used for naming network resources."
  type        = string
  default     = "network"
}

variable "os_disk_type" {
  description = "Storage account type for the OS disk of session hosts (e.g., Standard_LRS, Premium_LRS)."
  default     = "Standard_LRS"
}

variable "prefix" {
  description = "Prefix used in naming session hosts and related resources."
  type        = string
  default     = "avdtf"
}

variable "rdsh_count" {
  description = "Number of Remote Desktop Session Hosts (RDSH) to deploy."
  type        = number
  default     = 1
}

variable "rfc3339time" {
  description = "Expiration date and time for the host registration token (RFC3339 format)."
  default     = "2026-07-30T20:00:00Z"
}

variable "snet_address_prefix" {
  description = "IP address prefix (CIDR) for the subnet."
  type        = string
  default     = "10.10.0.0/24"
}

variable "storage_account_tags" {
  description = "Tags applied to storage accounts used by AVD."
  default = {
    Workload   = "FSLogix"
    Deployment = "Terraform"
  }
}

variable "vm_size" {
  description = "Azure VM size for session hosts (e.g., D2als_v6)."
  type        = string
  default     = "Standard_D2als_v6"
}

variable "vnet_address_space" {
  description = "IP address space (CIDR) for the virtual network."
  type        = string
  default     = "10.10.0.0/22"
}

variable "workload" {
  description = "Workload or application name for resources."
  type        = string
  default     = "tfrmavd"
}

variable "workspace_friendly_name" {
  description = "Friendly display name for the workspace."
  type        = string
  default     = "Terraform AVD"
}