# Define a local map for common Azure regions abbreviations
locals {
  location_abbr = {
    "uksouth"        = "uks"  # UK South [Europe]
    "westeurope"     = "weu"  # West Europe [Europe]
    "northeurope"    = "neu"  # North Europe [Europe]
    "southcentralus" = "scus" # South Central US [US]
    "eastus"         = "eus"  # East US [US]
    "westus"         = "wus"  # West US [US]
    "australiaeast"  = "aue"  # Australia East [Asia]
    "japaneast"      = "jpe"  # Japan East [Asia]
    "southeastasia"  = "sea"  # South East Asia [Asia]
    # [add any other azure regions as required]
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