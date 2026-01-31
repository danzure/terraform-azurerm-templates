# Define a local map for common Azure regions abbreviations
locals {
  location_abbr = {
    # Europe
    "uksouth"              = "uks"  # UK South
    "ukwest"               = "ukw"  # UK West
    "westeurope"           = "weu"  # West Europe
    "northeurope"          = "neu"  # North Europe
    "francecentral"        = "frc"  # France Central
    "germanywestcentral"   = "gwc"  # Germany West Central
    "switzerlandnorth"     = "szn"  # Switzerland North
    "switzerlandwest"      = "szw"  # Switzerland West
    "norwayeast"           = "nwe"  # Norway East
    "norwaywest"           = "nww"  # Norway West
    # Americas
    "eastus"               = "eus"  # East US
    "eastus2"              = "eu2"  # East US 2
    "westus"               = "wus"  # West US
    "westus2"              = "wu2"  # West US 2
    "westus3"              = "wu3"  # West US 3
    "centralus"            = "cus"  # Central US
    "northcentralus"       = "ncu"  # North Central US
    "southcentralus"       = "scus" # South Central US
    "canadacentral"        = "cac"  # Canada Central
    "canadaeast"           = "cae"  # Canada East
    "brazilsouth"          = "brs"  # Brazil South
    # Asia Pacific
    "australiaeast"        = "aue"  # Australia East
    "australiasoutheast"   = "ase"  # Australia Southeast
    "japaneast"            = "jpe"  # Japan East
    "japanwest"            = "jpw"  # Japan West
    "southeastasia"        = "sea"  # Southeast Asia
    "eastasia"             = "eas"  # East Asia
    "koreacentral"         = "krc"  # Korea Central
    "koreacentral2"        = "krc2" # Korea South (deprecated, use koreacentral)
    "indiacentral"         = "inc"  # India Central
    "indiasouth"           = "ins"  # India South
    "indiawest"            = "inw"  # India West
    # Middle East
    "uaenorth"             = "uan"  # UAE North
  }

  # funcation to generate the location abbriviation using the local map
  generate_loc_name = {
    location = local.location_abbr[var.location]
  }
}

locals {
  envrionment_abbr = {
    "production"  = "prod" # Production envrionment
    "uat"         = "uat"  # User Acceptance Testing (UAT) envrionment
    "development" = "dev"  # Development envrionment
  }
  # function to generate the abbriviation for the azure region 
  generate_env_name = {
    envrionment = local.envrionment_abbr[var.environment]
  }
}