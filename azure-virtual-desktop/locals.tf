# create a local map of location abbriviations for some common azure regions
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
    # add any addtional regions here 
  }
  # function to generate the location abbreviation
  generate_loc_name = {
    location = local.location_abbr[var.location]
  }
}

# create local map of environment abbreviations
locals {
  environment_abbr = {
    "prod" = "prod"
    "uat"  = "uat"
    "dev"  = "dev"
  }
  # function to generate the environment abbreviation
  generate_env_name = {
    environment = local.environment_abbr[var.environment]
  }
}