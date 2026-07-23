terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4"
    }
  }
}

provider "azurerm" {
  # Configuration options
}

provider "azuread" {
  # Configuration options
}