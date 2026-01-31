# configure the azure resource provider and the version used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }

  # set the hashicorp HCP terraform organisation + workspace for remote state file (remove if unused)
  cloud {
    organization = "danzure-org"
    workspaces {
      name = "hub-and-spoke-virtual-network"
    }
  }
}

# configure the Microsoft Azure Provider
provider "azurerm" {
  features {
  }
}